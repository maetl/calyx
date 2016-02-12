# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calyx/version'

Gem::Specification.new do |spec|
  spec.name          = 'calyx'
  spec.version       = Calyx::VERSION
  spec.authors       = ['Mark Rickerby']
  spec.email         = ['me@maetl.net']

  spec.summary       = %q{Generate text with declarative recursive grammars}
  spec.description   = %q{Calyx provides a simple API for generating text with declarative recursive grammars.}
  spec.homepage      = 'https://github.com/maetl/calyx'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
