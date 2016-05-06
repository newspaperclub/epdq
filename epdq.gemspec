# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name    = "epdq"
  s.version = "0.0.3"
  s.authors = ["Tom Taylor", "Alex Tomlins", "Andy Pearson"]
  s.email   = ["tom@tomtaylor.co.uk", "hello@wearefriday.com"]
  s.summary = "Ruby library for handling Barclaycard EPDQ requests and responses"

  s.files = Dir["{lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*_test.rb"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "test-unit", "~> 2.5.3"
end
