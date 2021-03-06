# Rail trip's characterization is implemented using a domain-specific language
# provided by [Characterizable](https://github.com/seamusabshere/characterizable).
module BrighterPlanet
  module RailTrip
    
    #### Rail trip: characterization
    # This module is used by [Brighter Planet](http://brighterplanet.com)'s
    # [emission estimate service](http://carbon.brighterplanet.com) to provide
    # curated attributes for the carbon model execution environment.
    #
    # For more information see:
    #
    #   * [API documentation](http://carbon.brighterplanet.com/rail_trips/options)
    #   * [Source code](https://github.com/brighterplanet/rail_trip)
    #
    module Characterization
      def self.included(base)
        ##### The characterization
        
        # This `characterize` block encapsulates the characterization. Typically
        # emitter models will be backed by ActiveRecord, which will provide
        # these attributes accessors based on database schema. The characteristics
        # listed here define the standard public API to RailTrip.
        base.characterize do
          has :date
          has :country
          has :origin_country
          has :destination_country
          has :origin
          has :destination
          has :rail_company  # e.g. Amtrak
          has :rail_traction # electric or diesel
          has :rail_class    # e.g. intercity
          has :distance, :measures => Measurement::BigLength
          has :duration, :measures => :time
        end
        
        # Additional characteristics are gleaned from the carbon model.
      end
    end
  end
end
