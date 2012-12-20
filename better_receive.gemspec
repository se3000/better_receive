# -*- encoding: utf-8 -*-
require File.expand_path('../lib/better_receive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Steve Ellis"]
  gem.email         = ["email@steveell.is"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "better_receive"
  gem.require_paths = ["lib"]
  gem.version       = BetterReceive::VERSION

  gem.add_dependency("rspec", "~> 2.0")
  gem.add_development_dependency("rake", ">= 0")
end
