# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "marmot/version"

Gem::Specification.new do |s|
  s.name        = "marmot"
  s.version     = Marmot::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dmitry Filimonov"]
  s.email       = ["me@dfilimonov.com"]
  s.homepage    = "http://github.com/petethepig/marmot"
  s.summary     = %q{Unofficial Font Squirrel webfont generator client}
  s.description = %q{Unofficial Font Squirrel webfont generator client}
  s.license     = "MIT"

  s.add_dependency 'trollop'
  s.add_dependency 'httmultiparty'
  s.add_dependency 'json'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
