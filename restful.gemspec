# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restful/version"

Gem::Specification.new do |s|
  s.name        = "restful"
  s.version     = Restful::VERSION
  s.authors     = ["Scotty Weeks"]
  s.email       = ["scott.weeks@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{ A role to mix into model classes for discoverable REST apis }
  s.description = %q{ A role to mix into model classes for discoverable REST apis  }

  s.rubyforge_project = "restful"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rails"

end
