$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "last_line/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "last_line"
  s.version     = LastLine::VERSION
  s.authors     = ['Eugene Kalenkovich']
  s.email       = ['rubify@softover.com']
  #s.homepage    = "TODO"
  s.summary     = 'Explicitly allow GET for specific actions only'
  s.description = 'Allow GET requests for specific actions only as the last line defense against XSRF'

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
end
