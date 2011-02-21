# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "slidize/version"

Gem::Specification.new do |s|
  s.name        = "slidize"
  s.version     = Slidize::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = ["Emil Loer"]
  s.email       = ["emil@koffietijd.net"]
  s.homepage    = "http://github.com/thedjinn/slidize"
  s.summary     = %q{Slidize is a themeable Kramdown/Markdown to HTML5 slide generator}
  s.description = %q{Slidize is a themeable Kramdown/Markdown to HTML5 slide generator}
  s.licenses    = ["MIT"]

  s.rubyforge_project = "slidize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
      
  s.add_dependency(%q<rack>, ["~> 1.1"])
  s.add_dependency(%q<kramdown>, [">= 0"])
  s.add_dependency(%q<haml>, ["~> 3.0.0"])
  s.add_dependency(%q<albino>, ["~> 1.2.0"])
  s.add_dependency(%q<turbosass>, [">= 0"])
end
