# -*- encoding: utf-8 -*-
require File.expand_path('../lib/allowance/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hendrik Mans"]
  gem.email         = ["hendrik@mans.de"]
  gem.description   = %q{A general-use permission management library with support for ActiveModel.}
  gem.summary       = %q{A general-use permission management library with support for ActiveModel.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "allowance"
  gem.require_paths = ["lib"]
  gem.version       = Allowance::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'watchr'
end
