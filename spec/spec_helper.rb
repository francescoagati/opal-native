require 'opal/spec/autorun'
require 'native'

if $0 == __FILE__
	Dir['spec/**/*.rb'].each { |spec| require spec }
end
