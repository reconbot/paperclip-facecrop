require 'rest_client'

class FaceCrop::Detector::FaceCom < FaceCrop::Detector::Base
  URL = "http://api.face.com/faces/detect.json"
  
  def detect(file)
    url = "#{URL}?api_key=#{@options[:api_key]}&api_secret=#{@options[:api_secret]}"
    response = RestClient.post url, :file => File.new(file)
    response = JSON.parse(response)
    
    photo = response['photos'].first
    photo['tags'].map do |tag|
      # values are returned as percentual values
      x = (photo['width'] * (tag['center']['x'] / 100.0)).to_i
      y = (photo['height'] * (tag['center']['y'] / 100.0)).to_i
      w = (photo['width'] * (tag['width'] / 100)).to_i  
      h = (photo['height'] * (tag['height'] / 100)).to_i
      
      FaceCrop::Detector::Region.new(x, y, w, h)
    end
  end
end
    