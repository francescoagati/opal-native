require 'opal'

desc 'Build specified dependencies to build dir'
task :dependencies do
	Opal::DependencyBuilder.new(out: 'build').build
end

desc 'Build latest opal-native to build dir'
task :build => :dependencies do
	Opal::Builder.new(files: 'lib', out: 'build/opal-native.js').build
end

desc 'Build latest opal-native ready for testing to build dir'
task :test => :dependencies do
	Opal::Builder.new(files: %w[lib spec], debug: true, out: 'build/opal-native.test.js').build
end

task :default => :build
