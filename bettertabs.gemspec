# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bettertabs/version"

Gem::Specification.new do |s|
  s.name        = "bettertabs"
  s.version     = Bettertabs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mario Izquierdo"]
  s.email       = ["tothemario@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{The better (simple, accessible, usable, flexible and fast) way to split content in tabs.}
  s.description = %q{The bettertabs helper defines the markup for a tabbed area in a easy and declarative way, using the appropiate JavaScript but ensuring accessibility and usability, no matter if the content is loaded statically, via ajax or the tabs are links. In the other hand, the CSS styles are up to you. }

  s.rubyforge_project = "bettertabs"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
