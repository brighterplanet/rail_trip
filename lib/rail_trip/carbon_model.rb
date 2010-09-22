# Rail trip's carbon model is implemented using a domain-specific language
# provided by [Leap](http://github.com/rossmeissl/leap).
module BrighterPlanet
  module RailTrip

    #### Rail trip: carbon model
    # This module is used by [Brighter Planet](http://brighterplanet.com)'s
    # [emission estimate service](http://carbon.brighterplanet.com) to provide
    # greenhouse gas emission estimates for rail trips.
    #
    # For more information see:
    #
    #   * [API documentation](http://carbon.brighterplanet.com/rail_trips/options)
    #   * [Source code](http://github.com/brighterplanet/rail_trip)
    #
    ##### Collaboration
    # Contributions to this carbon model are actively encouraged and warmly welcomed.
    # This library includes a comprehensive test suite to ensure that your changes
    # do not cause regressions. All changes shold include test coverage for new
    # functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme),
    # our emitter testing framework, for more information.
    module CarbonModel
      def self.included(base)
        ##### The carbon model
        
        # This `decide` block encapsulates the carbon model. The carbon model is
        # executed with a set of "characteristics" as input. These characteristics are
        # parsed from input received by the client request according to the
        # [characterization](characterization.html).
        base.decide :emission, :with => :characteristics do

          # The emission committee returns a carbon emission estimate in kilograms CO2e.
          committee :emission do # returns kg CO2

            # This calculation technique transforms amounts of diesel and electricity
            # consumed during the rail trip---via their current emission factors---to
            # an overall emission value. This value is divided by the passenger count
            # to obtain a per-passenger emission share.  
            quorum 'from fuel and passengers', :needs => [:diesel_consumed, :electricity_used, :passengers] do |characteristics|
              #((       litres diesel         ) * (  kilograms CO2 / litre diesel   ) + (           kwH                  ) * (     kilograms CO2 / kWh               ))
              (characteristics[:diesel_consumed] * base.research(:diesel_emission_factor) + characteristics[:electricity_used] * RailTrip.rail_trip_model.research(:electricity_emission_factor)) / characteristics[:passengers]
            end
          end
          
          # Generally the client will not know the exact amount of diesel consumed
          # during the rail trip, so it must be calculated.
          committee :diesel_consumed do # returns litres diesel
            
            # This technique uses trip distance and fuel efficiency to determine diesel
            # consumption.
            quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity] do |characteristics|
              #(          kilometres        ) * (     litres diesel / kilometre      )
              characteristics[:distance] * characteristics[:diesel_intensity]
            end
          end
          
          # Similarly, electricity consumption will typically be computed here.
          committee :electricity_used do # returns kWh

            # As with diesel consumption, we calculate electricity use by multiplying
            # distance by "electric intensity"--- an analogue of fuel efficiency.
            quorum 'from distance and electricity intensity', :needs => [:distance, :electricity_intensity] do |characteristics|
              #(       kilometres           ) * (         kWh / kilometre                  )
              characteristics[:distance] * characteristics[:electricity_intensity]
            end
          end
          
          # The distance of the rail trip is necessary to perform each of the above
          # calculations and can be calculated using several methods.
          committee :distance do # returns kilometres
            
            # The primary distance-calculation method is directly accepting an estimate from
            # the client.
            quorum 'from distance estimate', :needs => :distance_estimate do |characteristics|
              characteristics[:distance_estimate]
            end
            
            # Alternatively we can calculate distance by combining an estimate of trip
            # duration with the train's average speed.
            quorum 'from duration', :needs => [:duration, :speed] do |characteristics|
              #(       hours           ) * (        kph          )
              characteristics[:duration] * characteristics[:speed]
            end
            
            # Finally, we can assume the trip covered an average distance, scoped by
            # its rail class (subway vs. intercity, for example).
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              characteristics[:rail_class].distance
            end
          end
          
          # Diesel intensity is analogous to fuel efficiency (mpg), but are expressed
          # in units of fuel per unit of distance.
          committee :diesel_intensity do # returns litres diesel / vehicle kilometre
            
            # Brighter Planet has pre-calculated intensities for popular rail classes.
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              characteristics[:rail_class].diesel_intensity
            end
          end
          
          # Electricity intensity describes the amount of electric power consumed per
          # unit of train travel distance.
          committee :electricity_intensity do # returns kWh / vehicle kilometre
            
            # Again, intensities have been pre-calculated for popular rail classes.
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              characteristics[:rail_class].electricity_intensity
            end
          end
          
          # Speed is only necessary when used in combination with trip (temporal)
          # duration to determine distance.
          committee :speed do # returns kph
            
            # Rail classes provide average speed.
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              characteristics[:rail_class].speed
            end
          end
          
          # Each passenger is responsible for a share of the train trip's total
          # footprint.
          committee :passengers do
            
            # A passenger count can be gleaned from popular rail classes.
            quorum 'from rail class', :needs => :rail_class do |characteristics|
              characteristics[:rail_class].passengers
            end
          end
          
          # The vehicle used for a rail trip can be meaningfully assigned to one
          # of a list of categories called classes, including subways, intercity
          # rail, and commuter rail, for example.
          committee :rail_class do
            
            # If the client does not provide a rail class, we use an artificial
            # rail class, constructed using a weighted average approach.
            quorum 'default' do
              RailClass.fallback
            end
          end
        end
      end
    end
  end
end
