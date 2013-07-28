$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'last_line/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'last_line'
  s.version     = LastLine::VERSION
  s.authors     = ['Eugene Kalenkovich']
  s.email       = ['rubify@softover.com']
  s.homepage    = 'https://github.com/UncleGene/last_line'
  s.summary     = 'Last line of CSRF defence in your controllers'
  s.description = 'Explicitly allow GET requests for specific actions, verify authenticity token on GET'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*'] + %w[MIT-LICENSE Rakefile README.md]
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.1'
end
