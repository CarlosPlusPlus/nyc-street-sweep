require 'simple_geocoder'

class MapGenerator

  # Call simple_geocoder gem and return lat/long values.
  def self.location_data(location)
    SimpleGeocoder::Geocoder.new.geocode(location)
  end

  # Return lat/long values of a given location.
  def self.location_lat_lng(location)
    location_data = location_data(location)
    map_hash = location_data['results'][0]['geometry']['location']
    [map_hash["lat"], map_hash["lng"]]    
  end

  # Generate Javascript needed for Google map via ERB / Ruby HEREDOCS.
  def self.generate_js(map_gen,main_st="",from_st="",to_st="")

    # Generate static map when original index page is called.
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

    # Generate polyline map when streets are provided.
    else
      xy1 = location_lat_lng("#{main_st} & #{from_st}, NYC")
      xy2 = location_lat_lng("#{main_st} & #{to_st}, NYC")

      return <<-map_str
       var map;

       var intersection_1 = new google.maps.LatLng(#{xy1[0]}, #{xy1[1]});
       var intersection_2 = new google.maps.LatLng(#{xy2[0]}, #{xy2[1]});

       function initialize() {
         var mapOptions = {
           zoom: 17,
           center: intersection_1,
           mapTypeId: google.maps.MapTypeId.ROADMAP
         };

         map = new google.maps.Map(document.getElementById('map-canvas'),
             mapOptions);

         var block_parked_coords = [
             intersection_1,
             intersection_2
         ];

         var block_parked = new google.maps.Polyline({
           path: block_parked_coords,
           strokeColor: '#FF0000',
           strokeOpacity: 0.5,
           strokeWeight: 10
         });

         block_parked.setMap(map);

       }

       google.maps.event.addDomListener(window, 'load', initialize);
      map_str
    end
  end
  
end