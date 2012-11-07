require 'emitter'

require 'rail_trip/impact_model'
require 'rail_trip/characterization'
require 'rail_trip/data'
require 'rail_trip/relationships'
require 'rail_trip/summarization'
require 'mapquest_directions'
require 'geocoder'

module BrighterPlanet
  module RailTrip
    extend BrighterPlanet::Emitter
    scope 'The rail trip emission estimate is the anthropogenic emissions per passenger from rail fuel combustion. It includes includes CO2 emissions from direct fuel combustion and indirect fuel combustion to generate purchased electricity.'
  end
end
