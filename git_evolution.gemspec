# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_evolution/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_evolution'
  spec.version       = GitEvolution::VERSION
  spec.authors       = ['Kevin Jalbert']
  spec.email         = ['kevin.j.jalbert@gmail.com']
  spec.summary       = 'Gem that provides the ability to determine the evolution of code within a git repository'
  spec.description   = 'Gem that provides the ability to determine the evolution of code within a git repository'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['**/*']
  spec.test_files    = Dir['{test,spec,features}/**/*']
  spec.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'rake', '~> 10.0'
  spec.add_dependency 'rugged', '~> 0.21.0'
  spec.add_dependency 'chronic', '~> 0.10.0'

  spec.required_ruby_version = '~> 2.0'
end
