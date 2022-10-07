# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bettertabs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bettertabs"
  s.version     = Bettertabs::VERSION
  s.authors     = ["Mario Izquierdo"]
  s.email       = ["tothemario@gmail.com"]
  s.homepage    = "https://github.com/agoragames/bettertabs"
  s.summary     = %q{Just a simple, accessible, usable, flexible and fast way to split view content in tabs in a rails application.}
  s.description = %q{Bettertabs is a Rails 3.1+ engine that adds a helper and jQuery plugin to define the markup and behavior for a tabbed area in a easy and declarative way, using the appropiate JavaScript but ensuring accessibility and usability, no matter if the content is loaded statically, via ajax or just with links. }
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "jquery-rails"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'haml-rails'
end
