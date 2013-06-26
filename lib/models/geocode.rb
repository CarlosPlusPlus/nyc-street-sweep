require 'simple_geocoder'

class Geocode

  def self.location_data(location)
    SimpleGeocoder::Geocoder.new.geocode(location)
  end

  def self.location_lat_lng(location)
    location_data = location_data(location)
    location_data['results'][0]['geometry']['location']
    # => {"lat"=> 40.0185510,"lng"=> -105.2582644}
  end

end