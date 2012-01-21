require File.expand_path('../spec_helper', __FILE__)

describe Native::Object do
	before do
		@object = `{
			a: 42,

			b: function () {
				return 42;
			},

			c: function () {
				return { a: 23 };
			},

			d: function (a, h) {
				return h({a: a});
			}
		}`

		@test = Kernel.Native(@object)
	end

	it 'wraps an object properly' do
		`#{@test.to_native} == #{@object}`.should be_true
	end

	it 'calls a function as a method when present' do
		@test.b.should == 42
	end

	it 'calls a function as a method when present and returns a Native' do
		@test.c.a.should == 23
	end

	it 'calls handlers with proper wrapping' do
		@test.d(23) { |o| o.a }.should == 23
	end
end
