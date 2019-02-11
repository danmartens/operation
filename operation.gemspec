# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'operation/version'

Gem::Specification.new do |spec|
  spec.name          = 'operation'
  spec.version       = '0.0.1'
  spec.summary       = 'Primitives for isolating logic'
  spec.authors       = ['Dan Martens']
  spec.email         = 'dan@friendsoftheweb.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'dry-types', '~> 0.14.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'mutant-rspec', '~> 0.8.24'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
end