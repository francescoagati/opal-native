require File.expand_path('../spec_helper', __FILE__)

describe Native do
	before do
		@object = object = `{
			a: 23,

			b: function () {
				return 1337;
			}
		}`

		@test = Class.new {
			attr_accessor_bridge object, :a

			define_method_bridge object, :b

			define_singleton_method_bridge object, :b, :c
		}
	end

	it 'bridges correctly accessors' do
		test = @test.new

		`#@object.a`.should == 23
		`#@object.a = 42`
		`#@object.a`.should == 42

		test.a.should == 42

		test.a = 23
		test.a.should == 23
		`#@object.a`.should == 23
	end

	it 'bridges correctly methods' do
		@test.new.b.should == 1337
	end

	it 'bridges correctly singleton methods' do
		@test.c.should == 1337
	end
end
