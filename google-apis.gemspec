# -*- encoding: utf-8 -*-
require File.expand_path("../lib/google_apis/version", __FILE__)

Gem::Specification.new do |gem|
  gem.author        = "Paul Engel"
  gem.email         = "pm_engel@icloud.com"
  gem.summary       = %q{A thin layer on top of Google::API::Client for a more intuitive way of working (e.g. with BigQuery)}
  gem.description   = %q{A thin layer on top of Google::API::Client for a more intuitive way of working (e.g. with BigQuery)}
  gem.homepage      = "https://github.com/archan937/google-apis"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "google-apis"
  gem.require_paths = ["lib"]
  gem.version       = GoogleApis::VERSION

  gem.add_dependency "google-api-client", "~> 0.8.2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"
end
