module BrighterPlanet
  module RailTrip
    extend self

    def included(base)
      require 'cohort_scope'
      require 'falls_back_on'
      require 'falls_back_on/active_record_ext'

      require 'rail_trip/carbon_model'
      require 'rail_trip/characterization'
      require 'rail_trip/data'
      require 'rail_trip/summarization'

      base.send :include, BrighterPlanet::RailTrip::CarbonModel
      base.send :include, BrighterPlanet::RailTrip::Characterization
      base.send :include, BrighterPlanet::RailTrip::Data
      base.send :include, BrighterPlanet::RailTrip::Summarization
    end
    def rail_trip_model
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
