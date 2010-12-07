module BrighterPlanet
  module RailTrip
    module Relationships
      def self.included(target)
        target.belongs_to :rail_class
      end
    end
  end
end
