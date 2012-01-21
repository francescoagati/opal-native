require 'opal'

desc 'Build specified dependencies to build dir'
task :dependencies do
	Opal::DependencyBuilder.new(out: 'build').build
end

desc 'Build latest opal-native to build dir'
task :build => :dependencies do
	Opal::Builder.new(files: 'lib', out: 'build/opal-native.js').build
end

desc 'Run specs in spec/'
task :test => :build do
  Opal::Context.runner 'spec/**/*.rb'
end

task :default => :build
