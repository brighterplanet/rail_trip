# Rail trip's characterization is implemented using a domain-specific language
# provided by [Characterizable](http://github.com/seamusabshere/characterizable).
require 'characterizable'

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
    #   * [Source code](http://github.com/brighterplanet/rail_trip)
    #
    module Characterization
      def self.included(base)
        ##### The characterization
        base.send :include, Characterizable

        # This `characterize` block encapsulates the characterization. Typically
        # emitter models will be backed by ActiveRecord, which will provide
        # these attributes accessors based on database schema. The characteristics
        # listed here define the standard public API to RailTrip.
        base.characterize do
          has :rail_class
          has :duration, :measures => :time
          has :distance_estimate, :trumps => :duration, :measures => :length
        end
        
        # Additional characteristics are gleaned from the carbon model.
        base.add_implicit_characteristics
      end
    end
  end
end
