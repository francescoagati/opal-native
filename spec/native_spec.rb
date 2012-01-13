require File.expand_path('../spec_helper', __FILE__)

class Test
	include Native
end

describe Native do
	it 'creates a working object' do
		Test.new(42).to_native.should == 42
	end
end
