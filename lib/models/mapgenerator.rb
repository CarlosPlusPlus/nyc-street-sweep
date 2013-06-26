require 'simple_geocoder'

class MapGenerator

  def self.location_data(location)
    SimpleGeocoder::Geocoder.new.geocode(location)
  end

  def self.location_lat_lng(location)
    location_data = location_data(location)
    map_hash = location_data['results'][0]['geometry']['location']
    [map_hash["lat"], map_hash["lng"]]
    
    # => {"lat"=> 40.0185510,"lng"=> -105.2582644}
  end

end

puts "Main St & From Street = #{MapGenerator.location_lat_lng("3 AVENUE & EAST 118 STREET, NYC")}"
puts ""

puts "Main St & From Street = #{MapGenerator.location_lat_lng("3 AVENUE & EAST 119 STREET, NYC")}"
puts ""