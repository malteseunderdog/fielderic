require 'rubygems'
require 'geoip'
class PlayerLocator  
  
  def get_coordinates(ip_address)
    begin
      city_details = GeoIP.new('resources/GeoLiteCity.dat').city(ip_address)
      city_details['longitude'].to_s + "," + city_details['latitude'].to_s
    rescue
      puts 'Error: Could not locate IP address ' + ip_address
    end    
    city_details = ""
  end    
  
  def get_location(ip_address)
    begin
      city_details = GeoIP.new('resources/GeoLiteCity.dat').city(ip_address)
      city_details['city_name'] + ", " + city_details['country_name']
    rescue
      puts 'Error: Could not locate IP address ' + ip_address
    end
    city_details = ""
  end
end