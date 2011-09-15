# Rail trip's persistence schema is defined using a domain-specific language
# provided by [Data Miner](https://github.com/seamusabshere/data_miner).
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
    #   * [Source code](https://github.com/brighterplanet/rail_trip)
    #
    module Data
      def self.included(base)
        base.force_schema do
          date   'date'
          string 'country_iso_3166_code'
          string 'origin'
          string 'destination'
          string 'rail_company_name'
          string 'rail_class_name'
          string 'rail_traction_name'
          float  'distance'
          float  'duration'
        end
      end
    end
  end
end
