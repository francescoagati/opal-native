Gem::Specification.new {|s|
	s.name         = 'opal-native'
	s.version      = '0.0.4'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/opal/opal-native'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Easy support for native objects in Opal'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']

	# s.add_dependency 'opal-spec'
}
