# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'project_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'project_store'
  spec.version       = ProjectStore::VERSION
  spec.authors       = ['Laurent B.']
  spec.email         = ['lbnetid+gh@gmail.com']

  spec.summary       = %q{Store any Ruby object in a Yaml store.}
  spec.description   = %q{Store, retrieve and edit a collection of Yaml entities.}
  spec.homepage      = 'https://github.com/lbriais/project_store'
  spec.license       = 'MIT'


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'


end
