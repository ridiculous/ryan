# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ryan/version'

Gem::Specification.new do |spec|
  spec.name          = "ryan"
  spec.version       = Ryan::VERSION
  spec.authors       = ["Ryan Buckley"]
  spec.email         = ["arebuckley@gmail.com"]

  spec.summary       = %q{Reviews and rewrites rspec files}
  spec.description   = %q{Reviews and rewrites rspec files using the style I like}
  spec.homepage      = "https://github.com/ridiculous/ryan"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
