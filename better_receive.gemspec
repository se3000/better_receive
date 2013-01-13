# -*- encoding: utf-8 -*-
require File.expand_path('../lib/better_receive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Steve Ellis", "Matthew Horan"]
  gem.email         = ["email@steveell.is", "matt@matthoran.com"]
  gem.description   = %q{Assert that an object responds to a method before asserting that the method is received.}
  gem.summary       = %q{A better should_receive}
  gem.homepage      = "http://github.com/se3000/better_receive"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "better_receive"
  gem.require_paths = ["lib"]
  gem.version       = BetterReceive::VERSION

  gem.add_dependency("rspec", "~> 2.0")
  gem.add_development_dependency("rake", ">= 0")
  gem.add_development_dependency("pry", ">= 0")
end
