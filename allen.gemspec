# -*- encoding: utf-8 -*-
require File.expand_path('../lib/allen/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Taylor Smith"]
  gem.email         = ["taylor.smith@imulus.com"]
  gem.description   = "Quickly build an Umbraco project"
  gem.summary       = "Quickly build an Umbraco project"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "allen"
  gem.require_paths = ["lib"]
  gem.version       = Allen::VERSION

  gem.add_runtime_dependency(%q<thor>, ["~> 0.16.0"])
  gem.add_runtime_dependency(%q<i18n>, ["~> 0.6.1"])
  gem.add_runtime_dependency(%q<active_support>, ["~> 3.0.0"])
end
