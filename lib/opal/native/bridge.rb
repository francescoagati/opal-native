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
	def define_attr_bridge (target, name, getter, setter)
		if getter
			if Symbol === target
				if target.start_with? '@'
					define_method name do
						object = instance_variable_get(target)

						Kernel.Native(`#{Native === object ? object : object.to_native}[name]`)
					end
				else
					define_method name do
						object = __send__(target)

						Kernel.Native(`#{Native === object ? object : object.to_native}[name]`)
					end
				end
			else
				define_method name do |*args, &block|
					Kernel.Native(`target[name]`)
				end
			end
		end

		if setter
			if Symbol === target
				if target.start_with? '@'
					define_method "#{name}=" do |value|
						object = instance_variable_get(target)
						value  = value.to_native unless Native === value

						Kernel.Native(`#{Native === object ? object : object.to_native}[name] = value`)
					end
				else
					define_method "#{name}=" do |value|
						object = __send__(target)
						value  = value.to_native unless Native === value

						Kernel.Native(`#{Native === object ? object : object.to_native}[name] = value`)
					end
				end
			else
				define_method "#{name}=" do |value|
					value = value.to_native unless Native === value

					Kernel.Native(`target[name] = value`)
				end
			end
		end
	end

	def attr_accessor_bridge (target, *attrs)
		attrs.each {|attr|
			define_attr_bridge(target, attr, true, true)
		}

		self
	end

	def attr_reader_bridge (target, *attrs)
		attrs.each {|attr|
			define_attr_bridge(target, attr, true, false)
		}

		self
	end

	def attr_writer_bridge (target, *attrs)
		attrs.each { |attr|
			define_attr_bridge(target, attr, false, true)
		}

		self
	end

	def attr_bridge (target, name, setter = false)
		define_attr_bridge(target, name, true, setter)

		self
	end

	def define_method_bridge (target, name, ali = nil)
		if Symbol === target
			if target.start_with? '@'
				define_method ali || name do |*args, &block|
					object = instance_variable_get(target)

					Native.send(Native === object ? object : object.to_native, name, *args, &block)
				end
			else
				define_method ali || name do |*args, &block|
					object = __send__(target)

					Native.send(Native === object ? object : object.to_native, name, *args, &block)
				end
			end
		else
			define_method ali || name do |*args, &block|
				Native.send(target, name, *args, &block)
			end
		end

		nil
	end
end

module Kernel
	def define_singleton_method_bridge (target, name, ali = nil)
		define_singleton_method ali || name do |*args, &block|
			Native.send(target, name, *args, &block)
		end
	end
end
