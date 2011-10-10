require 'rail_trip'

class RailTripRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::RailTrip
end
