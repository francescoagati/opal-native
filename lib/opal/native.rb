#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Native
	def self.=== (other)
		`#{other} == null || !#{other}.o$klass`
	end

	def self.normalize (other)
		Native === other ? other : other.to_native
	end

	def self.send (object, name, *args, &block)
		args << block if block

		args = args.map {|obj|
			Native === obj ? obj : obj.to_native
		}

		Kernel.Native(`object[name].apply(object, args)`)
	end

	def self.included (klass)
		return super if klass.respond_to? :from_native

		class << klass
			def from_native (object)
				instance = allocate
				instance.instance_variable_set :@native, object

				instance
			end
		end
	end

	def initialize (value)
		if `value == null`
			raise ArgumentError, 'the passed value is null or undefined'
		end

		@native = value
	end

	def to_native
		@native
	end

	def native_send (name, *args, &block)
		unless Proc === `#@native[name]`
			raise NoMethodError, "undefined method `#{name}` for #{`#@native.toString()`}"
		end

		Native.send(@native, name, *args, &block)
	end

	alias __native_send__ native_send
end

class Native::Object
	include Native
	include Enumerable

	def initialize (value, options = {})
		super(value)

		if options[:only]
			@only = options[:only].flatten.compact.uniq
		end

		update!
	end

	def == (other)
		`#@native == #{Native(other).to_native}`
	end

	def === (other)
		Native::Object === other && `#@native == #{other.to_native}`
	end

	def [] (name)
		Kernel.Native(`#@native[name]`)
	end

	def []= (name, value)
		value = value.to_native unless Native === value

		`#@native[name] = #{value}`

		update!(name)

		value
	end

	def each
		return enum_for :each unless block_given?

		%x{
			for (var name in #@native) {
				#{yield Kernel.Native(`name`), Kernel.Native(`#@native[name]`)}
			}
		}

		self
	end

	def each_key
		return enum_for :each_key unless block_given?

		%x{
			for (var name in #@native) {
				#{yield Kernel.Native(`name`)}
			}
		}

		self
	end

	def each_value
		return enum_for :each_value unless block_given?

		%x{
			for (var name in #@native) {
				#{yield Kernel.Native(`#@native[name]`)}
			}
		}
	end

	def inspect
		"#<Native: #{`#@native.toString()`}>"
	end

	def keys
		each_key.to_a
	end

	def nil?
		`#@native === null || #@native === undefined`
	end

	def to_s
		`#@native.toString()`
	end

	def to_hash
		Hash[to_a]
	end

	def values
		each_value.to_a
	end

	def update! (name = nil)
		unless name
			%x{
				for (var name in #@native) {
					#{update!(`name`) if !@only || @only.include?(name)}
				}
			}

			return
		end

		if Proc === `#@native[name]`
			define_singleton_method name do |*args, &block|
				__native_send__(name, *args, &block)
			end

			if respond_to? "#{name}="
				singleton_class.undef_method "#{name}="
			end
		else
			define_singleton_method name do
				self[name]
			end

			define_singleton_method "#{name}=" do |value|
				self[name] = value
			end
		end
	rescue; end
end

module Kernel
	def Native (object, *methods)
		return if `object == null`

		Native === object ? Native::Object.new(object, only: methods) : object
	end
end

class Object
	def to_native
		raise TypeError, 'no specialized #to_native has been implemented'
	end
end

class Boolean
	def to_native
		`this.valueOf()`
	end
end

class Array
	def to_native
		map { |obj| Native === obj ? obj : obj.to_native }
	end
end

class Hash
	def to_native
		%x{
			var map    = this.map,
					result = {};

			for (var assoc in map) {
				var key   = map[assoc][0],
						value = map[assoc][1];

				result[key] = #{Native === `value` ? `value` : `value`.to_native};
			}

			return result;
		}
	end
end

class MatchData
	alias to_native to_a
end

class NilClass
	def to_native (result = undefined)
		result
	end
end

class Numeric
	def to_native
		`this.valueOf()`
	end
end

class Proc
	def to_native
		%x{
			var self = this;

			return (function () {
				return self.apply(self.$S, [null].concat(#{
					`$slice.call(arguments, 0)`.map { |o| Kernel.Native(o) }
				}));
			});
		}
	end
end

class Regexp
	def to_native
		`this.valueOf()`
	end
end

class String
	def to_native
		`this.valueOf()`
	end
end

require 'native/bridge'
