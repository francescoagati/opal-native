#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Module
	%x{
		function define_attr_bridge (klass, target, name, getter, setter) {
			if (getter) {
				$opal.defn(klass, $opal.mid_to_jsid(name), function() {
					var real = target;

					if (#{Symbol == `target`}) {
						real = target[0] == '@' ? this[target.substr(1)] : this[$opal.mid_to_jsid(target)].apply(this);
					}

					var result = real[name];

					return result == null ? nil : result;
				});
			}

			if (setter) {
				$opal.defn(klass, $opal.mid_to_jsid(name + '='), function (block, val) {
					var real = target;

					if (#{Symbol === `target`}) {
						real = target[0] == '@' ? this[target.substr(1)] : this[$opal.mid_to_jsid(target)].apply(this);
					}

					return real[name] = val;
				});
			}
		}
	}

	def attr_accessor_bridge (target, *attrs)
		%x{
			for (var i = 0, length = attrs.length; i < length; i++) {
				define_attr_bridge(this, target, attrs[i], true, true);
			}
		}

		self
	end

	def attr_reader_bridge (target, *attrs)
		%x{
			for (var i = 0, length = attrs.length; i < length; i++) {
				define_attr_bridge(this, target, attrs[i], true, false);
			}
		}

		self
	end

	def attr_writer_bridge (target, *attrs)
		%x{
			for (var i = 0, length = attrs.length; i < length; i++) {
				define_attr_bridge(this, target, attrs[i], false, true);
			}
		}

		self
	end

	def attr_bridge (target, name, setter = false)
		`define_attr_bridge(this, target, name, true, setter)`

		self
	end

	def define_method_bridge (object, name, ali = nil)
		if Symbol === object
			if object.start_with? ?@
				define_method ali || name do |*args, &block|
					Native.send(instance_variable_get(object), name, *args, &block)
				end
			else
				define_method ali || name do |*args, &block|
					Native.send(__send__(object), name, *args, &block)
				end
			end
		else
			define_method ali || name do |*args, &block|
				Native.send(object, name, *args, &block)
			end
		end

		nil
	end
end

module Kernel
	def define_singleton_method_bridge (*args)
		singleton_class.define_method_bridge(*args)
	end
end
