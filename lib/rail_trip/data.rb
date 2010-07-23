require 'data_miner'

module BrighterPlanet
  module RailTrip
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string  'name'
            date    'date'
            float   'duration'
            float   'distance_estimate'
            string  'rail_class_id'
          end

          process "pull dependencies" do
            run_data_miner_on_belongs_to_associations
          end
        end
      end
    end
  end
end
