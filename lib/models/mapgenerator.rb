require 'simple_geocoder'

class MapGenerator

  def self.location_data(location)
    SimpleGeocoder::Geocoder.new.geocode(location)
  end

  def self.location_lat_lng(location)
    location_data = location_data(location)
    map_hash = location_data['results'][0]['geometry']['location']
    [map_hash["lat"], map_hash["lng"]]    
  end

  def self.generate_js(map_gen,main_st="",from_st="",side_st="")
    # Generate a static map for original index
    if map_gen == false
      return <<-map_str
      var map;

      function initialize() {
        var mapOptions = {
          zoom: 11,
          center: new google.maps.LatLng(40.7537719, -73.98329100000001),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };

      map = new google.maps.Map(document.getElementById('map-canvas'),
          mapOptions);
      }

      google.maps.event.addDomListener(window, 'load', initialize);
      map_str

    # Calculate and highlight block based on addresses.
    else
      puts "I'll GET HERE EVENTUALLY."
    end

  end

end