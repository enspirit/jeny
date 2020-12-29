$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'jeny/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'jeny'
  s.version     = Jeny::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Simple scaffolding and code generation"
  s.description = "Simple scaffolding and code generation"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md','Gemfile','Rakefile', '{bin,lib,tasks}/**/*','README.md'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/jeny'
  s.license     = 'MIT'

  s.add_dependency "path", "~> 2.0"
  s.add_dependency "wlang", "~> 2.0"

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.7"
end
