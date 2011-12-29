require 'rubygems'

Gem::Specification.new do |spec|
  spec.name        = 'xfire'
  spec.summary     = 'Adding a Rails style to XQuery Apps'
  spec.description = %{The intention of this app is to remove the Enterpisey feeling from XQuery Apps and give them a more Rails feel to them.}
  spec.author      = 'Ryan Dew'
  spec.email       = 'ryan.j.dew@gmail.com'
  spec.executables = ['xfire']
  spec.files       = Dir['lib/**/*']
  spec.version     = '0.0.1'
  spec.add_dependency('ruby-xcc', '~> 0.5.3')
  spec.add_dependency('thor', '~> 0.14.6')
  spec.add_dependency('erubis', '~> 2.7.0')
end