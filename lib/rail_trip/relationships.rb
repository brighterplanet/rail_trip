module BrighterPlanet
  module RailTrip
    module Relationships
      def self.included(target)
        target.belongs_to :country, :foreign_key => 'country_iso_3166_code'
        target.belongs_to :rail_company, :foreign_key => 'rail_company_name'
        target.belongs_to :rail_class, :foreign_key => 'rail_class_name'
        target.belongs_to :rail_traction, :foreign_key => 'rail_traction_name'
      end
    end
  end
end
