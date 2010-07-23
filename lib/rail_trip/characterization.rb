require 'characterizable'

module BrighterPlanet
  module RailTrip
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :rail_class
          has :duration, :measures => :time
          has :distance_estimate, :trumps => :duration, :measures => :length
        end
        base.add_implicit_characteristics
      end
    end
  end
end
