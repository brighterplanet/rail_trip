require 'bundler/setup'

require 'sniff'
Sniff.init File.expand_path('../../..', __FILE__),
  :cucumber => true,
  :logger => false # change this to $stderr to see database activity

require 'geocoder'
class GeocoderWrapper
  def geocode(input)
    if res = ::Geocoder.search(input).first
      {
        latitude:  res.coordinates[0],
        longitude: res.coordinates[1],
        country_iso_3166_code:   res.country_code,
      }
    end
  end
end
BrighterPlanet::RailTrip.geocoder = GeocoderWrapper.new
