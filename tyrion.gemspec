require File.expand_path("../lib/tyrion/version", __FILE__)

# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name                      = "tyrion"
  s.summary                   = "Tyrion is yet another URL shortener implemented as a Rails Engine."
  s.description               = "Tyrion is yet another URL shortener Gem."
  s.files                     = `git ls-files`.split("\n")
  s.version                   = Tyrion::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = [ "John Lynch" ]
  s.email                     = [ "john@rigelgroupllc.com" ]
  s.homepage                  = "https://github.com/johnthethird/Tyrion"
  s.rubyforge_project         = "tyrion"
  s.required_rubygems_version = "> 1.3.6"
  s.add_dependency "rails", ">= 3.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
