# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autocorrect/version"

Gem::Specification.new do |s|
  s.name        = "autocorrect"
  s.version     = Autocorrect::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Graeme Mathieson"]
  s.email       = ["mathie@woss.name"]
  s.homepage    = "http://github.com/mathie/autocorrect"
  s.summary     = %q{If you can't spell, or type, your method names we're here to help.}
  s.description = %q{A crazy gem that 'corrects' your misspelling of method names. Please don't actually use it, I was just testing an idea in my head!}

  s.rubyforge_project = "autocorrect"

  s.add_dependency 'text'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
