module BrighterPlanet
  module RailTrip
    def self.included(base)
      base.extend ::Leap::Subject
      base.decide :emission, :with => :characteristics do
        committee :emission do # returns kg CO2
          quorum 'from fuel and passengers', :needs => [:diesel_consumed, :electricity_used, :passengers] do |characteristics|
            #((       litres diesel         ) * (  kilograms CO2 / litre diesel   ) + (           kwH                  ) * (     kilograms CO2 / kWh               ))
            (characteristics[:diesel_consumed] * research(:diesel_emission_factor) + characteristics[:electricity_used] * research(:electricity_emission_factor)) / characteristics[:passengers]
          end
        end
        
        committee :diesel_consumed do # returns litres diesel
          quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity] do |characteristics|
            #(          kilometres        ) * (     litres diesel / kilometre      )
            characteristics[:distance] * characteristics[:diesel_intensity]
          end
        end
        
        committee :electricity_used do # returns kWh
          quorum 'from distance and electricity intensity', :needs => [:distance, :electricity_intensity] do |characteristics|
            #(       kilometres           ) * (         kWh / kilometre                  )
            characteristics[:distance] * characteristics[:electricity_intensity]
          end
        end
        
        committee :distance do # returns kilometres
          quorum 'from distance estimate', :needs => :distance_estimate do |characteristics|
            characteristics[:distance_estimate]
          end
          
          quorum 'from duration', :needs => [:duration, :speed] do |characteristics|
            #(       hours           ) * (        kph          )
            characteristics[:duration] * characteristics[:speed]
          end
          
          quorum 'from rail class', :needs => :rail_class do |characteristics|
            characteristics[:rail_class].distance
          end
        end
        
        committee :diesel_intensity do # returns litres diesel / vehicle kilometre
          quorum 'from rail class', :needs => :rail_class do |characteristics|
            characteristics[:rail_class].diesel_intensity
          end
        end
        
        committee :electricity_intensity do # returns kWh / vehicle kilometre
          quorum 'from rail class', :needs => :rail_class do |characteristics|
            characteristics[:rail_class].electricity_intensity
          end
        end
        
        committee :speed do # returns kph
          quorum 'from rail class', :needs => :rail_class do |characteristics|
            characteristics[:rail_class].speed
          end
        end
        
        committee :passengers do
          quorum 'from rail class', :needs => :rail_class do |characteristics|
            characteristics[:rail_class].passengers
          end
        end
        
        committee :rail_class do
          quorum 'default' do
            RailClass.fallback
          end
        end
      end
    end
  end
end