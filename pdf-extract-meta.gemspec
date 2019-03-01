lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pdf/extract/version"

Gem::Specification.new do |spec|
  spec.name          = "pdf-extract-meta"
  spec.version       = PDF::Extract::VERSION
  spec.authors       = ["Matthew Chadwick"]
  spec.email         = ["matthew@wescrimmage.com"]
  spec.license       = "MIT"

  spec.summary       = "A command line utility for extracting annotation and field metadata from a PDF in JSON format."
  spec.homepage      = "https://github.com/Scrimmage/pdf-extract"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "commander", "~> 4.4"
  spec.add_dependency "oj", "~> 3.0"
  spec.add_dependency "pdf-reader", "~> 2.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
