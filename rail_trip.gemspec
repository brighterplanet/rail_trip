# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rail_trip/version"

Gem::Specification.new do |s|
  s.name = %q{rail_trip}
  s.version = BrighterPlanet::RailTrip::VERSION

  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2011-02-25}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of an rail_trip}
  s.email = %q{andy@rossmeissl.net}
  s.homepage = %q{https://github.com/brighterplanet/rail_trip}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    "LICENSE",
    "LICENSE-PREAMBLE",
    "README.rdoc"
  ]
  s.require_paths = ["lib"]
  s.rdoc_options = ["--charset=UTF-8"]
  
  s.add_runtime_dependency 'earth', '0.7.0'
  s.add_runtime_dependency 'emitter', '~>0.11.0' unless ENV['LOCAL_EMITTER']
  s.add_runtime_dependency 'mapquest_directions'
  s.add_runtime_dependency 'geokit'
  s.add_development_dependency 'sniff', '~>0.11.0' unless ENV['LOCAL_SNIFF']
end
