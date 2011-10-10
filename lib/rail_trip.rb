require 'emitter'
require 'mapquest_directions'

module BrighterPlanet
  module RailTrip
    extend BrighterPlanet::Emitter
    scope 'The rail trip emission estimate is the anthropogenic emissions per passenger from rail fuel combustion. It includes includes CO2 emissions from direct fuel combustion and indirect fuel combustion to generate purchased electricity.'
  end
end
