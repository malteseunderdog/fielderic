require 'rubygems'
require 'geoip'
class PlayerLocator  
  def get_location(ip_address)
    city_details = GeoIP.new('GeoLiteCity.dat').city(ip_address)
    city_details['longitude'].to_s + "," + city_details['latitude'].to_s    
  end    
end