# -*- encoding: utf-8 -*-
require File.expand_path('../lib/allen/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Taylor Smith", "Casey O'Hara"]
  gem.email         = ["taylor.smith@imulus.com", "casey.ohara@imulus.com"]
  gem.description   = "Quickly build and manage Umbraco projects"
  gem.summary       = "CLI and Rake tools for quickly building and managing Umbraco projects"
  gem.homepage      = "http://github.com/imulus/allen"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "allen"
  gem.require_paths = ["lib"]
  gem.version       = Allen::VERSION

  gem.add_runtime_dependency(%q<thor>, ["~> 0.16.0"])
  gem.add_runtime_dependency(%q<i18n>, ["~> 0.6.1"])
  gem.add_runtime_dependency(%q<active_support>, ["~> 3.0.0"])
  gem.add_runtime_dependency(%q<albacore>, ["0.3.4"])
  gem.add_runtime_dependency(%q<coyote>, ["1.2.2.rc1"])
  gem.add_runtime_dependency(%q<rake>, ["0.9.2.2"])

  gem.add_development_dependency(%q<rspec>, ["2.11.0"])
  gem.add_development_dependency(%q<listen>, ["0.4.7"])
  gem.add_development_dependency(%q<guard>, ["1.2.3"])
  gem.add_development_dependency(%q<guard-rspec>, ["1.2.1"])
  gem.add_development_dependency(%q<growl>, ["1.0.3"])
end
