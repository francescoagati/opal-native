require 'bundler/setup'
require 'opal'

desc 'Build specified dependencies into .'
task :dependencies do
	Opal::DependencyBuilder.new(stdlib: 'native', out: 'build').build
end

desc 'Build latest opal-native to current dir'
task :build do
	Opal::Builder.new('lib', join: 'build/opal-native.js').build
end

task :default => :build
