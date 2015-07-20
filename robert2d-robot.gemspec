# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'robot/version'

Gem::Specification.new do |spec|
  spec.name          = 'robert2d-robot'
  spec.version       = Robot::VERSION
  spec.authors       = ['Dave Robertson']
  spec.email         = ['dave.andrew.robertson.nz@gmail.com']
  spec.summary       = 'Toy Robot CLI'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~>1.10.5'
  spec.add_development_dependency 'rake', '~>10.4.2'
  spec.add_development_dependency 'rspec', '~>3.3.0'
  spec.add_development_dependency 'guard', '~>2.12.8'
  spec.add_development_dependency 'guard-rspec', '~>4.6.2'
  spec.add_development_dependency 'simplecov', '~>0.10.0'
  spec.add_development_dependency 'rubocop', '~>0.32.1'
  spec.add_development_dependency 'codeclimate-test-reporter', '~>0.2.0'
end
