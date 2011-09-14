# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Rail trip carbon model
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
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          committee :emission do
            #### Emission from distance and rail company rail class rail traction
            quorum 'from distance and rail company rail traction rail class', :needs => [:distance, :rail_company_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [rail company rail traction rail class](http://data.brighterplanet.com/rail_company_rail_traction_rail_classes) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:rail_company_rail_traction_rail_class].emission_factor
            end
            
            #### Emission from distance and rail company rail traction
            quorum 'from distance and rail company rail traction', :needs => [:distance, :rail_company_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [rail company rail traction](http://data.brighterplanet.com/rail_company_rail_tractions) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:rail_company_rail_traction].emission_factor
            end
            
            #### Emission from distance and country rail traction rail class
            quorum 'from distance and country rail traction rail class', :needs => [:distance, :country_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [country rail traction rail class](http://data.brighterplanet.com/country_rail_traction_rail_classes) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:country_rail_traction_rail_class].emission_factor
            end
            
            #### Emission from distance and rail company
            quorum 'from distance and rail company', :needs => [:distance, :rail_company],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [rail company](http://data.brighterplanet.com/rail_companies) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:rail_company].emission_factor
            end
            
            #### Emission from distance and country rail class
            quorum 'from distance and country rail class', :needs => [:distance, :country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [country rail class](http://data.brighterplanet.com/country_rail_classes) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:country_rail_class].emission_factor
            end
            
            #### Emission from distance and country rail traction
            quorum 'from distance and country rail traction', :needs => [:distance, :country_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [country rail traction](http://data.brighterplanet.com/country_rail_tractions) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:country_rail_traction].emission_factor
            end
            
            #### Emission from distance and country
            quorum 'from distance and country', :needs => [:distance, :country],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the [country](http://data.brighterplanet.com/countries) emission factor (*kg CO<sub>2</sub>* / passenger-km) to give *kg CO<sub>2</sub>*.
                characteristics[:distance] * characteristics[:country].rail_trip_emission_factor
            end
          end
          
          ### Diesel consumption calculation
          # Returns the trip's `diesel consumption` (*l / passenger*).
          committee :diesel_consumption do
            #### Diesel consumption from distance and rail company rail traction rail class
            quorum 'from distance and rail company rail traction rail class', :needs => [:distance, :rail_company_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company rail traction rail class` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company_rail_traction_rail_class].diesel_intensity
            end
            
            #### Diesel consumption from distance and rail company rail traction
            quorum 'from distance and rail company rail traction', :needs => [:distance, :rail_company_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company rail traction` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company_rail_traction].diesel_intensity
            end
            
            #### Diesel consumption from distance and country rail traction rail class
            quorum 'from distance and country rail traction rail class', :needs => [:distance, :country_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail traction rail class` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_traction_rail_class].diesel_intensity
            end
            
            #### Diesel consumption from distance and rail company
            quorum 'from distance and rail company', :needs => [:distance, :rail_company],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company].diesel_intensity
            end
            
            #### Diesel consumption from distance and country rail class
            quorum 'from distance and country rail class', :needs => [:distance, :country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail class` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_class].diesel_intensity
            end
            
            #### Diesel consumption from distance and country rail traction
            quorum 'from distance and country rail traction', :needs => [:distance, :country_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail traction` diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_traction].diesel_intensity
            end
            
            #### Diesel consumption from distance and country
            quorum 'from distance and country', :needs => [:distance, :country],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country` rail trip diesel intensity (*l / passenger-km*).
                characteristics[:distance] * characteristics[:country].rail_trip_diesel_intensity
            end
          end
          
          ### Electricity consumption calculation
          # Returns the trip's `electricity consumption` (*kWh / passenger*).
          committee :electricity_consumption do
            #### Electricity consumption from distance and rail company rail class rail traction
            quorum 'from distance and rail company rail traction rail class', :needs => [:distance, :rail_company_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company rail traction rail class` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company_rail_traction_rail_class].electricity_intensity
            end
            
            #### Electricity consumption from distance and rail company rail traction
            quorum 'from distance and rail company rail traction', :needs => [:distance, :rail_company_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company rail traction` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company_rail_traction].electricity_intensity
            end
            
            #### Electricity consumption from distance and country rail traction rail class
            quorum 'from distance and country rail traction rail class', :needs => [:distance, :country_rail_traction_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail traction rail class` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_traction_rail_class].electricity_intensity
            end
            
            #### Electricity consumption from distance and rail company
            quorum 'from distance and rail company', :needs => [:distance, :rail_company],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `rail company` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:rail_company].electricity_intensity
            end
            
            #### Electricity consumption from distance and country rail class
            quorum 'from distance and country rail class', :needs => [:distance, :country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail class` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_class].electricity_intensity
            end
            
            #### Electricity consumption from distance and country rail traction
            quorum 'from distance and country rail traction', :needs => [:distance, :country_rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country rail traction` electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:country_rail_traction].electricity_intensity
            end
            
            #### Electricity consumption from distance and country
            quorum 'from distance and country', :needs => [:distance, :country],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `distance` (*km*) by the `country` rail trip electricity intensity (*kWh / passenger-km*).
                characteristics[:distance] * characteristics[:country].rail_trip_electricity_intensity
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
                # Uses the [Mapquest directions API](http://developer.mapquest.com/web/products/dev-services/directions-ws) to calculate distance by road between the `origin location` and `destination location` (*km*).
                mapquest = ::MapQuestDirections.new characteristics[:origin_location].ll, characteristics[:destination_location].ll
                begin
                  mapquest.distance_in_kilometres
                rescue
                  nil
                end
            end
            
            #### Distance from duration and speed
            quorum 'from duration and speed', :needs => [:duration, :speed],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `duration` (*hours*) by the `speed` (*km / hour*) to give *km*.
                characteristics[:duration] * characteristics[:speed]
            end
            
            #### Distance from country rail class
            quorum 'from country rail class', :needs => [:country_rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) average trip `distance` (*km*).
                characteristics[:country_rail_class].distance
            end
            
            #### Distance from country
            quorum 'from country', :needs => :country,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) average trip `distance` (*km*).
                characteristics[:country].rail_trip_distance
            end
          end
          
          ### Duration calculation
          # Returns the client-input `duration` (*hours*).
          
          ### Speed calculation
          # Returns the trip's average speed (*km / hr*).
          committee :speed do
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
                characteristics[:country].rail_trip_speed
            end
          end
          
          ### Rail company rail traction rail class calculation
          # Returns the `rail company rail traction rail class`. This is a rail company-specific rail traction type and rail class (e.g. Amtrak diesel intercity).
          committee :rail_company_rail_traction_rail_class do
            #### Rail company rail traction rail class from rail company, rail traction, and rail class
            quorum 'from rail company, rail traction, and rail class', :needs => [:rail_company, :rail_traction, :rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail company rail traction rail class](http://data.brighterplanet.com/rail_company_rail_traction_rail_classes) based on the `rail company` name, `rail traction` name, and `rail class` name.
                RailCompanyRailTractionRailClass.find_by_rail_company_name_and_rail_traction_name_and_rail_class_name(
                  characteristics[:rail_company].name,
                  characteristics[:rail_traction].name,
                  characteristics[:rail_class].name
                )
            end
          end
          
          ### Rail company rail traction calculation
          # Returns the `rail company rail traction`. This is a rail company-specific rail traction type (e.g. Amtrak diesel).
          committee :rail_company_rail_traction do
            #### Rail company rail traction from rail company and rail traction
            quorum 'from rail company and rail traction', :needs => [:rail_company, :rail_traction],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail company rail traction](http://data.brighterplanet.com/rail_company_rail_tractions) based on the `rail company` name and `rail traction` name.
                RailCompanyRailTraction.find_by_rail_company_name_and_rail_traction_name(
                  characteristics[:rail_company].name,
                  characteristics[:rail_traction].name
                )
            end
          end
          
          ### Country rail traction rail class calculation
          # Returns the `country rail traction rail class`. This is a country-specific rail traction type and rail class (e.g. US diesel intercity).
          committee :country_rail_traction_rail_class do
            #### Country rail traction rail class from country, rail traction, and rail class
            quorum 'from country, rail traction, and rail class', :needs => [:country, :rail_traction, :rail_class],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail traction rail class](http://data.brighterplanet.com/country_rail_traction_rail_classes) based on the `country` ISO 3166 code, `rail traction` name, and `rail class` name.
                CountryRailTractionRailClass.find_by_country_iso_3166_code_and_rail_traction_name_and_rail_class_name(
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
            quorum 'from origin and destination locations', :needs [:origin_location, :destination_location],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Checks whether the `origin location` and `destination location` are in the same [country](http://data.brighterplanet.com/countries) and if so uses it..
                if characteristics[:origin].country_code == characteristics[:destination].country_code
                  Country.find_by_iso_3166_code(characteristics[:origin].country_code)
                end
            end
            
            #### Country from zip code
            quorum 'from zip code', :needs => :zip_code,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) the `zip code` is located in.
                characteristics[:zip_code].country
            end
            
            #### Country from rail company
            quorum 'from rail company', :needs => :rail_company,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) in which the `rail company` operates.
                characteristics[:rail_company].country
            end
            
            #### Default country
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Uses an artifical [country](http://data.brighterplanet.com/countries) representing global averages.
                Country.fallback
            end
          end
          
          ### Zip code calculation
          # Returns the client-input [zip code](http://data.brighterplanet.com/zip_codes) in which the trip occurred.
          
          ### Rail company calculation
          # Returns the client-input [rail company](http://data.brighterplanet.com/rail_companies).
          
          ### Destination location calculation
          # Returns the `destination location` (*lat / lng*).
          committee :destination_location do
            #### Destination location from destination
            quorum 'from destination', :needs => :destination,
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Uses the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the destination location (*lat / lng*).
                code = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:destination].to_s
                code.success ? code : nil
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
                # Uses the [Geokit](http://geokit.rubyforge.org/) geocoder to determine the origin location (*lat / lng*).
                code = ::Geokit::Geocoders::MultiGeocoder.geocode characteristics[:origin].to_s
                code.success ? code : nil
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

# #### Emission from CO<sub>2</sub> emission, CH<sub>4</sub> emission, and N<sub>2</sub>O emission
# quorum 'from co2 emission, ch4 emission, and n2o emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission],
#   # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#   :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#     # Sums the non-biogenic emissions to give *kg CO<sub>2</sub>e*.
#     characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission]
# end
# 
# ### CO<sub>2</sub> emission calculation
# # Returns the `co2 emission` (*kg*).
# committee :co2_emission do
#   #### CO<sub>2</sub> emission from electricity consumption, diesel variant, electricity variant, and timeframe
#   quorum 'from diesel consumption, electricity consumption, diesel properties, electricity co2 emission factor, and timeframe', :needs => [:diesel_consumption, :electricity_consumption, :diesel_properties, :electricity_co2_emission_factor],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
#       # FIXME TODO build this check into the input parser
#       date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
#       
#       # Checks whether the trip occurred during the `timeframe`.
#       if timeframe.include? characteristics[:date]
#         # Multiplies the `diesel consumption` (*l*) by the `diesel co2 emission factor` (*kg / l*) to give *kg*, multiplies `electricity consumption` (*kWh*) by the `electricity co2 emission factor` (*kg / kWh*) to give *kg*, and adds the two to give *kg*.
#         (characteristics[:diesel_consumption] * characteristics[:diesel_properties].co2_emission_factor) + (characteristics[:electricity_consumption] * characteristics[:electricity_co2_emission_factor])
#       else
#         # If the trip did not occur during the `timeframe`, `emission` is zero.
#         0
#       end
#   end
# end
# 
# ### CO<sub>2</sub> biogenic emission calculation
# # Returns the `co2 biogenic emission` (*kg*).
# committee :co2_biogenic_emission do
#   #### CO<sub>2</sub> biogenic emission from electricity consumption, diesel variant, electricity variant, and timeframe
#   quorum 'from diesel consumption, electricity consumption, diesel properties, electricity co2 biogenic emission factor, and timeframe', :needs => [:diesel_consumption, :electricity_consumption, :diesel_properties, :electricity_co2_biogenic_emission_factor],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
#       # FIXME TODO build this check into the input parser
#       date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
#       
#       # Checks whether the trip occurred during the `timeframe`.
#       if timeframe.include? characteristics[:date]
#         # Multiplies the `diesel consumption` (*l*) by the `diesel co2 biogenic emission factor` (*kg / l*) to give *kg*, multiplies `electricity consumption` (*kWh*) by the `electricity co2 biogenic emission factor` (*kg / kWh*) to give *kg*, and adds the two to give *kg*.
#         (characteristics[:diesel_consumption] * characteristics[:diesel_properties].co2_biogenic_emission_factor) + (characteristics[:electricity_consumption] * characteristics[:electricity_co2_biogenic_emission_factor])
#       else
#         # If the trip did not occur during the `timeframe`, `emission` is zero.
#         0
#       end
#   end
# end
# 
# ### CH<sub>4</sub> emission calculation
# # Returns the `ch4 emission` (*kg CO<sub>2</sub>e*).
# committee :ch4_emission do
#   #### CH<sub>4</sub> emission from electricity consumption, diesel variant, electricity variant, and timeframe
#   quorum 'from electricity consumption, electricity ch4 emission factor, and timeframe', :needs => [:electricity_consumption, :electricity_ch4_emission_factor],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
#       # FIXME TODO build this check into the input parser
#       date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
#       
#       # Checks whether the trip occurred during the `timeframe`.
#       if timeframe.include? characteristics[:date]
#         # Multiplies the `electricity consumption` (*kWh*) by the `electricity ch4 emission factor` (*kg CO<sub>2</sub>e / kWh*) to give *kg CO<sub>2</sub>e*.
#         characteristics[:electricity_consumption] * characteristics[:electricity_ch4_emission_factor]
#       else
#         # If the trip did not occur during the `timeframe`, `emission` is zero.
#         0
#       end
#   end
# end
# 
# ### N<sub>2</sub>O emission calculation
# # Returns the `n2o emission` (*kg CO<sub>2</sub>e*).
# committee :n2o_emission do
#   #### N<sub>2</sub>O emission from electricity consumption, diesel variant, electricity variant, and timeframe
#   quorum 'from electricity consumption, electricity n2o emission factor, and timeframe', :needs => [:electricity_consumption, :electricity_n2o_emission_factor],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
#       # FIXME TODO build this check into the input parser
#       date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
#       
#       # Checks whether the trip occurred during the `timeframe`.
#       if timeframe.include? characteristics[:date]
#         # Multiplies the `electricity consumption` (*kWh*) by the `electricity n2o emission factor` (*kg CO<sub>2</sub>e / kWh*) to give *kg CO<sub>2</sub>e*.
#         characteristics[:electricity_consumption] * characteristics[:electricity_n2o_emission_factor]
#       else
#         # If the trip did not occur during the `timeframe`, `emission` is zero.
#         0
#       end
#   end
# end
# 
# ### Electricity CO<sub>2</sub> emission factor calculation
# # Returns the electricity CO<sub>2</sub> emission factor (*kg / kWh*).
# committee :electricity_co2_emission_factor do
#   #### Electricity CO<sub>2</sub> emission factor from eGRID subregion and eGRID region
#   quorum 'from egrid subregion and egrid region', :needs => [:egrid_subregion, :egrid_region],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [egrid subregion](http://data.brighterplanet.com/egrid_subregions) CO<sub>2</sub> emission factor (*kg / kWh*) and divides by 1 - the [egrid region](http://data.brighterplanet.com/egrid_regions) loss factor to give *kg / kWh*.
#       characteristics[:egrid_subregion].electricity_co2_emission_factor / (1 - characteristics[:egrid_region].loss_factor)
#   end
#   
#   #### Electricity CO<sub>2</sub> emission factor from country
#   quorum 'from country', :needs => :country,
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [country](http://data.brighterplanet.com/countries) electricity CO<sub>2</sub> emission factor (*kg / kWh*).
#       characteristics[:country].electricity_co2_emission_factor
#   end
# end
# 
# ### Electricity CO<sub>2</sub> biogenic emission factor calculation
# # Returns the electricity CO<sub>2</sub> biogenic emission factor (*kg / kWh*).
# committee :electricity_co2_biogenic_emission_factor do
#   #### Electricity CO<sub>2</sub> biogenic emission factor from eGRID subregion and eGRID region
#   quorum 'from egrid subregion and egrid region', :needs => [:egrid_subregion, :egrid_region],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [egrid subregion](http://data.brighterplanet.com/egrid_subregions) CO<sub>2</sub> biogenic emission factor (*kg / kWh*) and divides by 1 - the [egrid region](http://data.brighterplanet.com/egrid_regions) loss factor to give *kg / kWh*.
#       characteristics[:egrid_subregion].electricity_co2_biogenic_emission_factor / (1 - characteristics[:egrid_region].loss_factor)
#   end
#   
#   #### Electricity CO<sub>2</sub> biogenic emission factor from country
#   quorum 'from country', :needs => :country,
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [country](http://data.brighterplanet.com/countries) electricity CO<sub>2</sub> biogenic emission factor (*kg / kWh*).
#       characteristics[:country].electricity_co2_biogenic_emission_factor
#   end
# end
# 
# ### Electricity CH<sub>4</sub> emission factor calculation
# # Returns the electricity CH<sub>4</sub> emission factor (*kg CO<sub>2</sub>e/ kWh*).
# committee :electricity_ch4_emission_factor do
#   #### Electricity CH<sub>4</sub> emission factor from eGRID subregion and eGRID region
#   quorum 'from egrid subregion and egrid region', :needs => [:egrid_subregion, :egrid_region],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [egrid subregion](http://data.brighterplanet.com/egrid_subregions) CH<sub>4</sub> emission factor (*kg CO<sub>2</sub>e/ kWh*) and divides by 1 - the [egrid region](http://data.brighterplanet.com/egrid_regions) loss factor to give *kg / kWh*.
#       characteristics[:egrid_subregion].electricity_ch4_emission_factor / (1 - characteristics[:egrid_region].loss_factor)
#   end
#   
#   #### Electricity CH<sub>4</sub> emission factor from country
#   quorum 'from country', :needs => :country,
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [country](http://data.brighterplanet.com/countries) electricity CH<sub>4</sub> emission factor (*kg CO<sub>2</sub>e/ kWh*).
#       characteristics[:country].electricity_ch4_emission_factor
#   end
# end
# 
# ### Electricity N<sub>2</sub>O emission factor calculation
# # Returns the electricity N<sub>2</sub>O emission factor (*kg CO<sub>2</sub>e/ kWh*).
# committee :electricity_n2o_emission_factor do
#   #### Electricity N<sub>2</sub>O emission factor from eGRID subregion and eGRID region
#   quorum 'from egrid subregion and egrid region', :needs => [:egrid_subregion, :egrid_region],
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [egrid subregion](http://data.brighterplanet.com/egrid_subregions) N<sub>2</sub>O emission factor (*kg CO<sub>2</sub>e/ kWh*) and divides by 1 - the [egrid region](http://data.brighterplanet.com/egrid_regions) loss factor to give *kg / kWh*.
#       characteristics[:egrid_subregion].electricity_n2o_emission_factor / (1 - characteristics[:egrid_region].loss_factor)
#   end
#   
#   #### Electricity N<sub>2</sub>O emission factor from country
#   quorum 'from country', :needs => :country,
#     # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
#     :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
#       # Looks up the [country](http://data.brighterplanet.com/countries) electricity N<sub>2</sub>O emission factor (*kg CO<sub>2</sub>e/ kWh*).
#       characteristics[:country].electricity_n2o_emission_factor
#   end
# end
# 
# ### Diesel properties calculation
# # Returns the properties of diesel fuel used.
# committee :diesel_properties do
#   #### Diesel properties from fuel data
#   quorum 'from fuel data' do
#     # Looks up the properties of [Distillate Fuel Oil No. 2](http://data.brighterplanet.com/fuels).
#     Fuel.find_by_name("Distillate Fuel Oil No. 2")
#   end
# end
