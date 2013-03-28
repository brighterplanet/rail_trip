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
        base.col :date, :type => :date
        base.col :country_iso_3166_code
        base.col :origin_country_iso_3166_code
        base.col :destination_country_iso_3166_code
        base.col :origin
        base.col :destination
        base.col :rail_company_name
        base.col :rail_class_name
        base.col :rail_traction_name
        base.col :distance, :type => :float
        base.col :duration, :type => :float
      end
    end
  end
end
