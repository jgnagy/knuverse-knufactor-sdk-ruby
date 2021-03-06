# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knuverse/knufactor/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'knuverse-knufactor'
  spec.version       = KnuVerse::Knufactor::VERSION
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ['Jonathan Gnagy']
  spec.email         = ['jgnagy@knuedge.com']

  spec.summary       = 'KnuVerse Knufactor Ruby SDK'
  spec.homepage      = 'https://github.com/KnuVerse/knuverse-knufactor-sdk-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['yard.run'] = 'yri'

  spec.required_ruby_version = '~> 2.0'
  spec.post_install_message  = 'Thanks for installing the KnuVerse Knufactor Ruby SDK!'
  spec.platform              = Gem::Platform::RUBY

  spec.add_runtime_dependency 'linguistics', '~> 2.1'
  spec.add_runtime_dependency 'rest-client', '~> 2.0'
  spec.add_runtime_dependency 'will_paginate', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'travis', '~> 1.8'
end
