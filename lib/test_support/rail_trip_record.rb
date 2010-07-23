require 'rail_trip'

class RailTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::RailTrip
  belongs_to :rail_class
    
  conversion_accessor :distance_estimate, :external => :miles, :internal => :kilometres
  
  falls_back_on
  
  class << self
    def research(key)
      case key
      when :diesel_emission_factor
        22.59.pounds_per_gallon.to(:kilograms_per_litre) # CO2 / diesel  https://brighterplanet.sifterapp.com/projects/30/issues/455
      when :electricity_emission_factor
        1.36.pounds.to(:kilograms) # CO2 / kWh https://brighterplanet.sifterapp.com/projects/30/issues/455
      end
    end
  end
  
  def emission_date
    created_at.to_date #FIXME we should add a date characteristic for this emitter
  end
end
