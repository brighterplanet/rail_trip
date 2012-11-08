# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require 'earth/locality/country'
require 'earth/rail/country_rail_class'
require 'earth/rail/country_rail_traction'
require 'earth/rail/country_rail_traction_class'

## Rail trip impact model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of passenger rail travel**.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the emission calculation. Each calculation is named according to the `value` it returns.
#
##### Timeframe and date
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the trip's `date`. For example, if the `timeframe` is January 2010, a trip that occurred on January 11, 2010 will have emissions but a trip that occurred on Febraury 1, 2010 will not. If the user does not specify a `timeframe` it defaults to the current calendar year.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the `values` it requires ('default' methods do not require any values). Methods are ignored if any of the values they require are unvailable. Calculations are ignored if all of their methods are unavailable.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method or will be unavailable.
#
##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module RailTrip
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          ### Greenhosuse gas emission calculation
          # Returns the `greenhouse gas emission` estimate (*kg CO<sub>2</sub>e*).
          committee :carbon do
            #### Greenhouse gas emission from distance, co2 emission factor, date, and timeframe
            quorum 'from distance, co2 emission factor, date, and timeframe', :needs => [:distance, :co2_emission_factor, :date],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies the `distance` (*km*) by the `co2 emission factor` (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                  characteristics[:distance] * characteristics[:co2_emission_factor]
                else
                  # If the `date` does not fall within the `timeframe`, `greenhouse gas emission` is zero.
                  0
                end
            end
          end
          
          ### CO2 emission factor calculation
          # Returns the trip's `co2 emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
          committee :co2_emission_factor do
=begin
            currently all european countries have same ef for rail traction and rail traction class
            when this changes may need to split distance by country
            e.g. make Eurostar from London to Avignon use UK ef in UK and France ef in France
=end
            
            #### CO2 emission factor from country rail traction rail class
            quorum 'from country rail traction rail class', :needs => :country_rail_traction_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail traction rail class](http://data.brighterplanet.com/country_rail_traction_classes) co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                characteristics[:country_rail_traction_class].co2_emission_factor
            end
            
            #### CO2 emission factor from rail company
            quorum 'from rail company', :needs => :rail_company,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail company](http://data.brighterplanet.com/rail_companies) co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                characteristics[:rail_company].co2_emission_factor
            end
            
            #### CO2 emission factor from country rail class
            quorum 'from country rail class', :needs => :country_rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                characteristics[:country_rail_class].co2_emission_factor
            end
            
            #### CO2 emission factor from country rail traction
            quorum 'from country rail traction', :needs => :country_rail_traction,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail traction](http://data.brighterplanet.com/country_rail_tractions) co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                characteristics[:country_rail_traction].co2_emission_factor
            end
            
            #### CO2 emission factor from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                characteristics[:country].rail_trip_co2_emission_factor
            end
            
            #### CO2 emission factor from default
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the global average rail trip co2 emission factor (*kg CO<sub>2</sub>* / passenger-km).
                Country.fallback.rail_trip_co2_emission_factor
            end
          end
          
          ### Diesel consumption calculation
          # Returns the trip's `diesel consumption` (*kWh / passenger*).
          committee :diesel_consumption do
            #### Diesel consumption from distance and diesel intensity
            quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `diesel intensity` (*kWh / passenger-km*) to give *kWh*.
                characteristics[:distance] * characteristics[:diesel_intensity]
            end
          end
          
          ### Electricity consumption calculation
          # Returns the trip's `electricity consumption` (*kWh / passenger*).
          committee :electricity_consumption do
            #### Electricity consumption from distance and electricity intensity
            quorum 'from distance and electricity intensity', :needs => [:distance, :electricity_intensity],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `electricity intensity` (*kWh / passenger-km*) to give *kWh*.
                characteristics[:distance] * characteristics[:electricity_intensity]
            end
          end
          
          ### Diesel intensity calculation
          # Returns the trip's `diesel intensity` (*l / passenger-km*).
          committee :diesel_intensity do
            #### Diesel intensity from country rail traction rail class
            quorum 'from country rail traction rail class', :needs => :country_rail_traction_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail traction rail class` diesel intensity (*kWh / passenger-km*).
                characteristics[:country_rail_traction_class].diesel_intensity
            end
            
            #### Diesel intensity from rail company
            quorum 'from rail company', :needs => :rail_company,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `rail company` diesel intensity (*kWh / passenger-km*).
                characteristics[:rail_company].diesel_intensity
            end
            
            #### Diesel intensity from country rail class
            quorum 'from country rail class', :needs => :country_rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail class` diesel intensity (*kWh / passenger-km*).
                characteristics[:country_rail_class].diesel_intensity
            end
            
            #### Diesel intensity from country rail traction
            quorum 'from country rail traction', :needs => :country_rail_traction,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail traction` diesel intensity (*kWh / passenger-km*).
                characteristics[:country_rail_traction].diesel_intensity
            end
            
            #### Diesel intensity from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country` rail trip diesel intensity (*kWh / passenger-km*).
                characteristics[:country].rail_trip_diesel_intensity
            end
            
            #### Diesel intensity from default
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the global average rail trip diesel intensity (*kWh / passenger-km*).
                Country.fallback.rail_trip_diesel_intensity
            end
          end
          
          ### Electricity intensity calculation
          # Returns the trip's `electricity intensity` (*kWh / passenger-km*).
          committee :electricity_intensity do
            #### Electricity intensity from country rail traction rail class
            quorum 'from country rail traction rail class', :needs => :country_rail_traction_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail traction rail class` electricity intensity (*kWh / passenger-km*).
                characteristics[:country_rail_traction_class].electricity_intensity
            end
            
            #### Electricity intensity from rail company
            quorum 'from rail company', :needs => :rail_company,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `rail company` electricity intensity (*kWh / passenger-km*).
                characteristics[:rail_company].electricity_intensity
            end
            
            #### Electricity intensity from country rail class
            quorum 'from country rail class', :needs => :country_rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail class` electricity intensity (*kWh / passenger-km*).
                characteristics[:country_rail_class].electricity_intensity
            end
            
            #### Electricity intensity from country rail traction
            quorum 'from country rail traction', :needs => :country_rail_traction,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country rail traction` electricity intensity (*kWh / passenger-km*).
                characteristics[:country_rail_traction].electricity_intensity
            end
            
            #### Electricity intensity from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the `country` rail trip electricity intensity (*kWh / passenger-km*).
                characteristics[:country].rail_trip_electricity_intensity
            end
            
            #### Electricity intensity from default
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the global average rail trip electricity intensity (*kWh / passenger-km*).
                Country.fallback.rail_trip_electricity_intensity
            end
          end
          
          ### Distance calculation
          # Returns the trip's `distance` (*km*).
          committee :distance do
            #### Distance from client input
            # **Complies:** All
            #
            # Uses the client-input distance (*km*).
            
            #### Distance from origin location and destination location
            quorum 'from origin and destination locations', :needs => [:origin_location, :destination_location],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Uses the [Mapquest directions API](http://developer.mapquest.com/web/products/dev-services/directions-ws) to calculate distance by road between the `origin location` and `destination location` in *km*.
                mapquest = ::MapQuestDirections.new characteristics[:origin_location].coordinates.join(','), characteristics[:destination_location].coordinates.join(',')
                mapquest.status.to_i == 0 ? mapquest.distance_in_miles.miles.to(:kilometres) : nil
            end
            
            #### Distance from duration and speed
            quorum 'from duration and speed', :needs => [:duration, :speed],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `duration` (*hours*) by the `speed` (*km / hour*) to give *km*.
                (characteristics[:duration] / 3600.0) * characteristics[:speed]
            end
            
=begin
            FIXME TODO add from rail company
=end
            
            #### Distance from country rail class
            quorum 'from country rail class', :needs => [:country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) average trip `distance` (*km*).
                characteristics[:country_rail_class].trip_distance
            end
            
            #### Distance from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) average trip `distance` (*km*).
                characteristics[:country].rail_trip_distance
            end
            
            #### Distance from default
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the global average trip `distance` (*km*).
                Country.fallback.rail_trip_distance
            end
          end
          
          ### Duration calculation
          # Returns the client-input `duration` (*hours*).
          
          ### Speed calculation
          # Returns the trip's average speed (*km / hr*).
          committee :speed do
=begin
            FIXME TODO add from rail company
=end
            
            #### Speed from country rail class
            quorum 'from country rail class', :needs => [:country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) average rail `speed` (*km / hr*).
                characteristics[:country_rail_class].speed
            end
            
            #### Speed from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) average rail 'speed' (*km / hr*).
                characteristics[:country].rail_speed
            end
            
            #### Speed from default
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the global average rail 'speed' (*km / hr*).
                Country.fallback.rail_speed
            end
          end
          
          ### Country rail traction rail class calculation
          # Returns the `country rail traction rail class`. This is a country-specific rail traction type and rail class (e.g. US diesel intercity).
          committee :country_rail_traction_class do
            #### Country rail traction rail class from country, rail traction, and rail class
            quorum 'from country, rail traction, and rail class', :needs => [:country, :rail_traction, :rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail traction rail class](http://data.brighterplanet.com/country_rail_traction_classes) based on the `country` ISO 3166 code, `rail traction` name, and `rail class` name.
                CountryRailTractionClass.find_by_country_iso_3166_code_and_rail_traction_name_and_rail_class_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:rail_traction].name,
                  characteristics[:rail_class].name
                )
            end
          end
          
          ### Country rail class calculation
          # Returns the `country rail class`. This is a country-specific rail class (e.g. US intercity).
          committee :country_rail_class do
            #### Country rail class from country and rail class
            quorum 'from country and rail class', :needs => [:country, :rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) based on the `country` ISO 3166 code and `rail class` name.
                CountryRailClass.find_by_country_iso_3166_code_and_rail_class_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:rail_class].name
                )
            end
          end
          
          ### Country rail traction calculation
          # Returns the `country rail traction`. This is a country-specific rail traction type (e.g. US diesel).
          committee :country_rail_traction do
            #### Country rail traction from country and rail traction
            quorum 'from country and rail traction', :needs => [:country, :rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail traction](http://data.brighterplanet.com/country_rail_tractions) based on the `country` ISO 3166 code and `rail traction` name.
                CountryRailTraction.find_by_country_iso_3166_code_and_rail_traction_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:rail_traction].name
                )
            end
          end
          
          ### Rail class calculation
          # Returns the client-input [rail class](http://data.brighterplanet.com/rail_classes).
          
          ### Rail traction calculation
          # Returns the client-input [rail traction](http://data.brighterplanet.com/tractions).
          
          ### Country calculation
          # Returns the `country` in which the trip occurred.
          committee :country do
            #### Country from client input
            # **Complies:** All
            #
            # Uses the client-input [country](http://data.brighterplanet.com/countries).
            
            #### Country from origin and destination locations
            quorum 'from origin and destination locations', :needs => [:origin_location, :destination_location],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Checks whether the `origin location` and `destination location` are in the same [country](http://data.brighterplanet.com/countries) and if so uses it..
                if characteristics[:origin_location].country_code == characteristics[:destination_location].country_code
                  Country.find_by_iso_3166_code(characteristics[:origin_location].country_code)
                end
            end
            
            #### Country from rail company
            quorum 'from rail company', :needs => :rail_company,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) in which the `rail company` operates.
                characteristics[:rail_company].country
            end
          end
          
          ### Rail company calculation
          # Returns the client-input [rail company](http://data.brighterplanet.com/rail_companies).
          
          ### Destination location calculation
          # Returns the `destination location` (*lat / lng*).
          committee :destination_location do
            #### Destination location from destination
            quorum 'from destination', :needs => :destination,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Use [Geocoder](http://www.rubygeocoder.com/) to determine the `destination` location (*lat, lng*).
                Geocoder.search(characteristics[:destination]).first
            end
          end
          
          ### Destination calculation
          # Returns the client-input `destination`.
          
          ### Origin location calculation
          # Returns the `origin location` (*lat / lng*).
          committee :origin_location do
            #### Origin location from origin
            quorum 'from origin', :needs => :origin,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Use the [Geocoder](http://www.rubygeocoder.com/) to determine the `origin` location (*lat, lng*).
                Geocoder.search(characteristics[:origin]).first
            end
          end
          
          ### Origin calculation
          # Returns the client-input `origin`.
          
          ### Date calculation
          # Returns the `date` on which the trip occurred.
          committee :date do
            #### Date from client input
            # **Complies:** All
            #
            # Uses the client-input `date`.
            
            #### Date from timeframe
            quorum 'from timeframe',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Assumes the trip occurred on the first day of the `timeframe`.
                timeframe.from
            end
          end
        end
      end
    end
  end
end
