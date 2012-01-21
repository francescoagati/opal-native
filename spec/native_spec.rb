require File.expand_path('../spec_helper', __FILE__)

describe Native do
	before do
		@test = Class.new {
			include Native
		}
	end

	it 'creates a working object' do
		@test.new(42).to_native.should == 42
	end

	it 'sends calls properly' do
		@test.new(42).native_send(:toString, 16).should == '2a'
	end
end
