module BrighterPlanet
  module RailTrip
    module CarbonModel
      class TripSegment < Struct.new(:country_iso_3166_code, :rail_class_name, :traction_name, :distance, :diesel_consumption, :electricity_consumption, :diesel_emission_factor, :electricity_emission_factor)
        
      end
    end
  end
end
