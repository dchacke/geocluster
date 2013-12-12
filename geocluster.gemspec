# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geocluster/version'

Gem::Specification.new do |spec|
  spec.name          = "geocluster"
  spec.version       = Geocluster::VERSION
  spec.authors       = ["Dennis Charles Hackethal"]
  spec.email         = ["dennis.hackethal@gmail.com"]
  spec.description   = %q{Clustering coordinates made easy.}
  spec.summary       = %q{This ruby gem allows you to easily cluster an array of geographic coordinates.}
  spec.homepage      = "https://github.com/dchacke/geocluster"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pr_geohash"
  spec.add_development_dependency "geocoder"
end
