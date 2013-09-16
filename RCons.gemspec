# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'RCons/version'

Gem::Specification.new do |spec|
  spec.name        = "RCons"
  spec.version     = RCons::VERSION
  spec.authors     = ["Norbert Melzer"]
  spec.email       = ["timmelzer@gmail.com"]
  spec.description = %q{Ruby Constructor}
  spec.summary     = %q{Ruby Constructor}
  spec.homepage    = ""
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 1.9.3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "logging"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
