# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'penumbra/version'

Gem::Specification.new do |spec|
  spec.name          = "penumbra"
  spec.version       = Penumbra::VERSION
  spec.authors       = ["Dennis Walters"]
  spec.email         = ["dwalters@engineyard.com"]

  spec.summary       = %q{Naive caching/indexing, a shadow of solr}
  spec.homepage      = "https://github.com/ess/penumbra"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|tmp)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_runtime_dependency "oj", "~> 2.12"
end
