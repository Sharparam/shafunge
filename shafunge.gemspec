# encoding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shafunge/version'

Gem::Specification.new do |spec|
  spec.name          = 'shafunge'
  spec.version       = Shafunge::VERSION
  spec.authors       = ['Adam Hellberg']
  spec.email         = ['sharparam@sharparam.com']

  spec.summary       = 'Befunge interpreter in Ruby'
  spec.homepage      = 'https://github.com/Sharparam/shafunge'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
end
