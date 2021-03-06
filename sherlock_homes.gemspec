# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sherlock_homes/version'

Gem::Specification.new do |spec|
  spec.name          = "sherlock_homes"
  spec.version       = SherlockHomes::VERSION
  spec.authors       = ["Jeff Deville"]
  spec.email         = ["jeffdeville@gmail.com"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         =
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime
  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'geocoder', '~> 1.2'
  spec.add_dependency 'capybara', '~> 2.4.4'
  spec.add_dependency 'site_prism', '~> 2.7'

  # Developmenet
  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'

  # Test
  spec.add_development_dependency 'rspec-given', '~> 3.7'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'capybara-screenshot'
end
