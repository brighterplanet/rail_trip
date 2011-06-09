# Rail trip's persistence schema is defined using a domain-specific language
# provided by [Data Miner](http://github.com/seamusabshere/data_miner).
module BrighterPlanet
  module RailTrip

    #### Rail trip: persistence schema
    # This module is used by [Brighter Planet](http://brighterplanet.com)'s
    # [emission estimate service](http://carbon.brighterplanet.com) to provide
    # a persistence structure, which is in turn used by the [characterization](characterization.html).
    #
    # For more information see:
    #
    #   * [API documentation](http://carbon.brighterplanet.com/rail_trips/options)
    #   * [Source code](http://github.com/brighterplanet/rail_trip)
    #
    module Data
      def self.included(base)
        base.create_table do
          string  'rail_class_name'
          float   'duration'
          float   'distance_estimate'
          date    'date'
        end
      end
    end
  end
end
