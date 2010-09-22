# Rail trip's summarization strategy is implemented using a domain-specific language
# provided by [Summary Judgement](http://github.com/rossmeissl/summary_judgement).
module BrighterPlanet
  module RailTrip

    #### Rail trip: summarization strategy
    # This module is used by [Brighter Planet](http://brighterplanet.com)'s
    # [emission estimate service](http://carbon.brighterplanet.com) to provide
    # summaries for rail trips.
    #
    # For more information see:
    #
    #   * [API documentation](http://carbon.brighterplanet.com/rail_trips/options)
    #   * [Source code](http://github.com/brighterplanet/rail_trip)
    #
    module Summarization
      def self.included(base)
        ##### The carbon model

        # This `summarize` block encapsulates the summarization strategy, including
        # terminology and inflection preference.
        base.summarize do |has|
          has.adjective lambda { |rail_trip| "#{rail_trip.distance_estimate_in_miles.adaptive_round(1)}-mile" }, :if => :distance_estimate
          has.adjective lambda { |rail_trip| "#{rail_trip.duration}-hour" }, :if => :duration
          has.identity 'rail trip'
          has.verb :take
          has.aspect :perfect
        end
      end
    end
  end
end
