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
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          committee :emission do
            #### From fuel and passengers
            quorum 'from date, fuel, emission factors, and passengers', :needs => [:diesel_consumed, :diesel_emission_factor, :electricity_consumed, :electricity_emission_factor, :passengers, :date],
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                # Checks whether the trip occurred during the `timeframe`
                if timeframe.include? date
                  # - Multiplies `diesel use` (*l*) by the `diesel emission factor` (*kg / l*) to give diesel emissions (*kg CO<sub>2</sub>*)
                  # - Multiplies `electricity use` (*kWh*) by the `electricity emission factor` (*kg CO<sub>2</sub>e / kWh*) to give electricity emissions (*kg CO<sub>2</sub>e*)
                  # - Adds diesel and electricity emissions to give total emissions (*kg CO<sub>2</sub>e*)
                  # - Divides by passengers to give emissions per passenger (*kg CO<sub>2</sub>e*)
                  (characteristics[:diesel_consumed] * characteristics[:diesel_emission_factor] + characteristics[:electricity_consumed] * characteristics[:electricity_emission_factor]) / characteristics[:passengers]
                else
                  # If the trip did not occur during the `timeframe`, `emission` is zero
                  0
                end
            end
          end
          
          ### Diesel emission factor calculation
          # Returns the `diesel emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :diesel_emission_factor do
            #### Default diesel emission factor
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
              # Looks up [Distillate Fuel Oil No. 2](http://data.brighterplanet.com/fuels)'s `co2 emission factor` (*kg / l*).
              diesel = Fuel.find_by_name "Distillate Fuel Oil No. 2"
              diesel.co2_emission_factor
            end
          end
          
          ### Electricity emission factor calculation
          # Returns the `electricity emission factor` (*kg CO<sub>2</sub>e / kWh*).
          committee :electricity_emission_factor do
            #### Default electricity emission factor
            quorum 'default',
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Looks up the [U.S. Average](http://data.brighterplanet.com/egrid_subregions) `electricity emission factor` (*kg CO<sub>2</sub>e / l*).
                subregion = EgridSubregion.find_by_abbreviation "US"
                # Looks up the [U.S. Average](http://data.brighterplanet.com/egrid_regions) grid region `loss factor`.
                region = subregion.egrid_region
                # Divides the `electricity emission factor` by (1 - `loss factor`) to account for transmission and distribution losses.
                emission_factor = subregion.electricity_emission_factor / (1 - region.loss_factor)
                emission_factor
            end
          end
          
          ### Diesel consumed calculation
          # Returns the `diesel use` (*l*).
          committee :diesel_consumed do
            #### From distance and diesel intensity
            quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity],
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies `distance` (*km*) by `diesel intensity` (*l / km*) to give *l*.
                characteristics[:distance] * characteristics[:diesel_intensity]
            end
          end
          
          ### Electricity consumed calculation
          # Returns the `electricity use` (*kWh*).
          committee :electricity_consumed do
            #### From distance and electricity intensity
            quorum 'from distance and electricity intensity', :needs => [:distance, :electricity_intensity],
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies `distance` (*km*) by `electricity intensity` (*kWh / km*) to give *kWh*.
                characteristics[:distance] * characteristics[:electricity_intensity]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` traveled (*km*).
          committee :distance do
            #### Distance from distance estimate
            quorum 'from distance estimate', :needs => :distance_estimate,
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Uses the `distance estimate` (*km*).
                characteristics[:distance_estimate]
            end
            
            #### Distance from duration and speed
            quorum 'from duration and speed', :needs => [:duration, :speed],
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Multiplies the `duration` (*hours*) by the `speed` (*km / hour*) to give *km*.
                characteristics[:duration] * characteristics[:speed]
            end
            
            #### Distance from rail class
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `distance`.
              characteristics[:rail_class].distance
            end
          end
          
          ### Distance estimate calculation
          # Returns the trip's `distance estimate` (*km*)
            #### Distance estimate from client input
            # **Complies:** All
            #
            # Uses the client-input `distance estimate` (*km*).
          
          ### Duration calculation
          # Returns the trip's `duration` (*hours*).
            #### Duration from client input
            # **Complies:** All
            #
            # Uses the client-input `duration` (*hours*).
          
          ### Diesel intensity calculation
          # Returns the `diesel intensity` (*l / km*).
          committee :diesel_intensity do
            #### Diesel intensity from rail class
            quorum 'from rail class', :needs => :rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `diesel intensity`.
                characteristics[:rail_class].diesel_intensity
            end
          end
          
          ### Electricity intensity calculation
          # Returns the `electricity intensity` (*kWh / km*).
          committee :electricity_intensity do
            #### Electricity intensity from rail class
            quorum 'from rail class', :needs => :rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `electricity intensity`.
                characteristics[:rail_class].electricity_intensity
            end
          end
          
          ### Speed calculation
          # Returns the average `speed` (*km / hour*).
          committee :speed do
            #### Speed from rail class
            quorum 'from rail class', :needs => :rail_class, 
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `speed`.
                characteristics[:rail_class].speed
            end
          end
          
          ### Passengers calculation
          # Returns the total number of `passengers`.
          committee :passengers do
            #### Passengers from rail class
            quorum 'from rail class', :needs => :rail_class,
              # **Complies:** GHG Protocol Scope 3, ISO-140641, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr]  do |characteristics|
                # Looks up the [rail class](http://data.brighterplanet.com/rail_classes) `passengers`.
                characteristics[:rail_class].passengers
            end
          end
          
          ### Rail class calculation
          # Returns the [rail class](http://data.brighterplanet.com/rail_classes). This is the type of rail the trip used.
          committee :rail_class do
            #### Rail class from client input
            # **Complies:** All
            #
            # Uses the client-input [rail class](http://data.brighterplanet.com/rail_classes).
            
            #### Default rail class
            quorum 'default', 
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                # Uses an artificial [rail class](http://data.brighterplanet.com/rail_classes) representing the U.S. average.
                RailClass.find_by_name "US average"
            end
          end
          
          ### Date calculation
          # Returns the `date` on which the trip occurred.
          committee :date do
            #### Date from client input
            # **Complies:** All
            #
            # Uses the client-input `date`.
            
            #### Date from timeframe
            quorum 'from timeframe',
              # **Complies:** GHG Protocol Scope 3, ISO-14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Assumes the trip occurred on the first day of the `timeframe`.
                timeframe.from
            end
          end
          
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
