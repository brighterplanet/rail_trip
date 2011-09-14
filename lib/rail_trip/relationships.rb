module BrighterPlanet
  module RailTrip
    module Relationships
      def self.included(target)
        target.belongs_to :zip_code
        target.belongs_to :country
        target.belongs_to :rail_company
        target.belongs_to :rail_class
        target.belongs_to :rail_traction
      end
    end
  end
end
