Gem::Specification.new do |s|
  s.name    = "epdq"
  s.version = "0.0.1"
  s.authors = ["Tom Taylor"]
  s.email   = "tom@tomtaylor.co.uk"
  s.summary = "Ruby library for handling Barclaycard EPDQ requests and responses"

  s.files = Dir["{lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*_test.rb"]

  s.add_development_dependency "test-unit", "~> 2.5.3"
end
