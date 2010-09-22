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
        ##### The carbon model
        base.data_miner do
          # This `schema` block encapsulates the persistence schema.
          schema do
            string  'name'
            date    'date'
            float   'duration'
            float   'distance_estimate'
            string  'rail_class_id'
          end

          # This `process` block indicates that RailTrip's associated classes
          # should populate themselves according to their own DataMiner
          # instructions.
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
