require 'rail_trip'

class RailTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::RailTrip
end
