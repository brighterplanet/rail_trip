require 'rail_trip'

class RailTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::RailTrip
  belongs_to :rail_class
    
  conversion_accessor :distance, :external => :miles, :internal => :kilometres
end
