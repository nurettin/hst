# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hst/version'

Gem::Specification.new do |spec|
  spec.name          = "hst"
  spec.version       = Hst::VERSION
  spec.authors       = ["Nurettin Onur TUĞCU"]
  spec.email         = ["onur.tugcu@gmail.com"]

  spec.summary       = %q{Read & Write Metatrader 4 .hst files}
  spec.description   = %q{Includes a Hst::Reader and Hst::Writer class for reading and writing Metatrader 4 .hst files.}
  spec.homepage      = "https://github.com/nurettin/hst"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
