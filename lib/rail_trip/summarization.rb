require 'summary_judgement'

module BrighterPlanet
  module RailTrip
    module Summarization
      def self.included(base)
        base.extend SummaryJudgement
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
