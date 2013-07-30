# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wp_conversion/version'

Gem::Specification.new do |spec|
  spec.name          = "wp_conversion"
  spec.version       = WpConversion::VERSION
  spec.authors       = ["Tamara Temple"]
  spec.email         = ["tamouse@gmail.com"]
  spec.description   = %q{Convert a Wordpress XML backup into markdown files suitable for a jekyll site}
  spec.summary       = %q{Convert a Wordpress XML backup into markdown files suitable for a jekyll site}
  spec.homepage      = "http://github.com/tamouse/wp_conversion"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake')
  spec.add_dependency('methadone', '~> 1.3.0')
  spec.add_dependency('activesupport')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('guard')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('guard-cucumber')
end
