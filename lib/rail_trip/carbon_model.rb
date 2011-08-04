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
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the trip's `date`. For example, if the `timeframe` is January 2010, a trip that occurred on January 11, 2010 will have emissions but a trip that occurred on Febraury 1, 2010 will not.
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
          committee :emission do
            quorum 'from diesel emission, electricity emission, verified date, and timeframe', :needs => [:diesel_emission, :electricity_emission, :verified_date],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip occurred during the `timeframe`.
                if timeframe.include? characteristics[:verified_date]
                  # Sums the `diesel emission` (*kg CO<sub>2</sub>e*) and `electricity emission` (*kg CO<sub>2</sub>e*) to give (*kg CO<sub>2</sub>e*).
                  characteristics[:diesel_emission] + characteristics[:electricity_emission]
                else
                  # If the trip did not occur during the `timeframe`, `emission` is zero.
                  0
                end
            end
          end
          
          committee :diesel_emission do
            quorum 'from trip segments', :needs => :trip_segments,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `diesel consumption` for each `trip segment` (*kg*) by that segment's `diesel emission factor` (*kg CO<sub>2</sub>e / kg*), and sums to give (*kg CO<sub>2</sub>e).
                characteristics[:trip_segments].map do |segment|
                  segment.diesel_consumption * segment.diesel_emission_factor
                end.sum
                #FIXME TODO test this
            end
            
            quorum 'from diesel consumption and diesel emission factor', :needs => [:diesel_consumption, :diesel_emission_factor],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the trip `diesel consumption` by the trip `diesel emission factor` (*kg CO<sub>2</sub>e / kg*) to give (*kg CO<sub>2</sub>e).
                characteristics[:diesel_consumption] * characteristics[:diesel_emission_factor]
                #FIXME TODO test this
            end
          end
          
          committee :electricity_emission do
            quorum 'from trip segments', :needs => :trip_segments,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `electricity consumption` for each `trip segment` (*kg*) by that segment's `electricity emission factor` (*kg CO<sub>2</sub>e / kg*), and sums to give (*kg CO<sub>2</sub>e).
                characteristics[:trip_segments].map do |segment|
                  segment.electricity_consumption * segment.electricity_emission_factor
                end.sum
                #FIXME TODO test this
            end
            
            quorum 'from electricity consumption and electricity emission factor', :needs => [:electricity_consumption, :electricity_emission_factor],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the trip `electricity consumption` by the trip `electricity emission factor` (*kg CO<sub>2</sub>e / kg*) to give (*kg CO<sub>2</sub>e).
                characteristics[:electricity_consumption] * characteristics[:electricity_emission_factor]
                #FIXME TODO test this
            end
          end
          
          committee :trip_segments do
            quorum 'from route', :needs => :route,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                #FIXME TODO based on the mapquest directions, construct an array TripSegments (one for each country the trip passes through), each of which has:
                # country
                # rail_class
                # traction
                # distance
                
                # then, for each segment, calculate as if using the relevant committee:
                # diesel_consumption
                # electricity_consumption
                # diesel_emission_factor
                # electricity_emission_factor
                
                # Maybe put all this calculation in the TripSegment module?
                
                #FIXME TODO test this
            end
          end
          
          committee :diesel_emission_factor do
            quorum 'from country, rail class, and traction', :needs => [:country_rail_class_traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class traction](http://data.brighterplanet.com/country_rail_class_tractions) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_rail_class_traction].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country and rail class', :needs => [:country_rail_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_rail_class].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country and traction', :needs => [:country_traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country traction](http://data.brighterplanet.com/country_tractions) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_traction].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from rail class and traction', :needs => [:rail_class, :traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class traction](http://data.brighterplanet.com/rail_class_tractions) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:rail_class_traction].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from rail class', :needs => :rail_class,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:rail_class].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from traction', :needs => :traction,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [traction](http://data.brighterplanet.com/tractions) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:traction].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) `diesel emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country].diesel_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
          end
          
          committee :electricity_emission_factor do
            quorum 'from country, rail class, and traction', :needs => [:country_rail_class_traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class traction](http://data.brighterplanet.com/country_rail_class_tractions) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_rail_class_traction].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country and rail class', :needs => [:country_rail_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_rail_class].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country and traction', :needs => [:country_traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country traction](http://data.brighterplanet.com/country_tractions) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country_traction].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from rail class and traction', :needs => [:rail_class, :traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class traction](http://data.brighterplanet.com/rail_class_tractions) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:rail_class_traction].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from rail class', :needs => :rail_class,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:rail_class].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from traction', :needs => :traction,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [traction](http://data.brighterplanet.com/tractions) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:traction].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) `electricity emission factor` (*kg CO<sub>2</sub>e / passenger-km*).
                characteristics[:country].electricity_emission_factor
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
          end
          
          committee :distance do
            quorum 'from distance estimate', :needs => :distance_estimate,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Uses the `distance estimate` (*km*).
                characteristics[:distance_estimate]
            end
            
            quorum 'from route', :needs => :route,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Calculates the distance based on the `route` to give *km*.
                #FIXME TODO calculate total distance from route
                #FIXME TODO test this
            end
            
            quorum 'from duration and speed', :needs => [:duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `duration` (*hours*) by the `speed` (*km / hour*) to give *km*.
                characteristics[:duration] * characteristics[:speed]
            end
            
            #FIXME NOTE: keeping this b/c it's where the US data will be; we could add more quorums but don't think it's worth it now
            quorum 'from country and rail class', :needs => [:country, :rail_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) average trip `distance`.
                characteristics[:country_rail_classes].distance
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country](http://data.brighterplanet.com/countries) average trip `distance` (*km*).
                characteristics[:country].rail_trip_distance
                #FIXME TODO add relevant data to earth, esp. fallback
                #FIXME TODO test this
            end
          end
          
          ### Distance estimate calculation
          # Returns the client-input `distance estimate` (*km*)
          
          committee :route do
            quorum 'from origin and destination', :needs => [:origin, :destination],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                #FIXME TODO get the route via road from mapquest
            end
          end
          
          ### Destination calculation
          # Returns the client-input `destination`.
          # FIXME TODO we might want to check here that this is a location Mapquest recognizes
          
          ### Origin calculation
          # Returns the client-input `origin`.
          # FIXME TODO we might want to check here that this is a location Mapquest recognizes
          
          ### Duration calculation
          # Returns the client-input `duration` (*hours*).
          
          committee :speed do
            #FIXME NOTE: keeping this b/c it's where the US data will be; we could add more quorums but don't think it's worth it now
            quorum 'from country and rail class', :needs => [:country, :rail_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [country rail class](http://data.brighterplanet.com/country_rail_classes) average `speed`.
                characteristics[:country_rail_class].speed
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
            
            quorum 'from country', :needs => :country,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the [country](http://data.brighterplanet.com/countries) average `speed`.
                characteristics[:country].speed
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
          end
          
          committee :country_rail_class_traction do
            quorum 'from country, rail class, and traction', :needs => [:country, :rail_class, :traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                CountryRailClassTraction.find_by_country_iso_3166_code_and_rail_class_name_and_traction_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:rail_class].name,
                  characteristics[:traction].name,
                )
            end
          end
          
          committee :country_rail_class do
            quorum 'from country and rail class', :needs => [:country, :rail_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                CountryRailClass.find_by_country_iso_3166_code_and_rail_class_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:rail_class].name,
                )
            end
          end
          
          committee :country_traction do
            quorum 'from country and traction', :needs => [:country, :traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                CountryTraction.find_by_country_iso_3166_code_and_traction_name(
                  characteristics[:country].iso_3166_code,
                  characteristics[:traction].name,
                )
            end
          end
          
          committee :rail_class_traction do
            quorum 'from rail class and traction', :needs => [:rail_class, :traction],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                RailClassTraction.find_by_rail_class_name_and_traction_name(
                  characteristics[:rail_class].name,
                  characteristics[:traction].name,
                )
            end
          end
          
          committee :country do
            #### Country from client input
            # **Complies:** All
            #
            # Uses the client-input [country](http://data.brighterplanet.com/countries).
            
            #FIXME NOTE: this is really just for the fallback - in most cases we should have a route
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Uses an artificial [country](http://data.brighterplanet.com/countries) representing global averages.
                Country.fallback
                #FIXME TODO add relevant data to earth
                #FIXME TODO test this
            end
          end
          
          ### Rail class calculation
          # Returns the client-input [rail class](http://data.brighterplanet.com/rail_classes).
          
          ### Traction calculation
          # Returns the client-input [traction](http://data.brighterplanet.com/rail_tractions).
          
          committee :verified_date do
            quorum 'from date', :needs => :date,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Parses the user-entered date to ensure it is valid.
                characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
            end
            
            quorum 'from timeframe',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Assumes the trip occurred on the first day of the `timeframe`.
                timeframe.from
            end
          end
          
          ### Date calculation
          # Returns the client-input date
          
          ### Timeframe calculation
          # Returns the `timeframe`.
          # This is the period during which to calculate emissions.
            
            #### Timeframe from client input
            # **Complies:** All
            #
            # Uses the client-input `timeframe`.
            
            #### Default timeframe
            # **Complies:** All
            #
            # Uses the current calendar year.
        end
      end
    end
  end
end
