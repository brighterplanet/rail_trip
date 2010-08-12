require 'emitter'

module BrighterPlanet
  module RailTrip
    extend BrighterPlanet::Emitter

    def self.rail_trip_model
      if Object.const_defined? 'RailTrip'
        ::RailTrip
      elsif Object.const_defined? 'RailTripRecord'
        RailTripRecord
      else
        raise 'There is no rail_trip model'
      end
    end
  end
end
