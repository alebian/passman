# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'passman/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'passman'
  spec.version       = Passman::VERSION
  spec.authors       = ['Alejandro Bezdjian']
  spec.email         = 'alebezdjian@gmail.com'
  spec.date          = Date.today
  spec.summary       = 'Password manager.'
  spec.description   = "PassMan is a password manager that stores your passwords encrypted, let's you retreive them and create new ones."
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.require_paths = ['lib']
  spec.homepage      = 'https://github.com/alebian/passman'
  spec.license       = 'MIT'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})

  spec.add_dependency 'bcrypt', '~> 3.1'
  spec.add_dependency 'colorize', '~> 0.7', '>= 0.7.5'
  spec.add_dependency 'clipboard', '~> 1.1', '>= 1.1.0'
  spec.add_dependency 'highline', '>= 1.7.8', '< 3.0'

  spec.add_development_dependency 'bundler', '>= 1.3.0', '< 3.0'
  spec.add_development_dependency 'byebug', '>= 9.0.5', '~> 11.1' if RUBY_VERSION >= '2.0.0'
  spec.add_development_dependency 'rubocop', '~> 1.11'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.27'
end
