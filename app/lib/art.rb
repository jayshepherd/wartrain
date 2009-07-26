module Art
  
   def update_art(url, path)
     unless url.nil? : save_url(url, path) end
     if File.exists?(path) : resize(path) end
   end

   # Based on
   # http://www.swards.net/2009/04/google-image-search-in-rails-using.html
   def google_art(keyword)
     require 'json'
     url = "http://ajax.googleapis.com/ajax/services/search/images?"
     url<<"sz=large&q=#{CGI.escape(keyword)}&v=1.0&as_filetype=jpg"
     json_results = open(url) {|f| f.read };
     results = JSON.parse(json_results)
     image_array = results['responseData']['results']
     image = image_array[0] if image_array
     return image['unescapedUrl']
   end
    
private 

  def save_url(url, path)
    require 'net/http'
    begin  
      url = url.gsub('http://', '')
      @server = url.split('/').first
      remote_path = url.gsub(@server, '')
      unless @server.nil? or remote_path.nil?
        Net::HTTP.start(@server) { |http|
          resp = http.get(remote_path)
          open( path, 'w' ) { |file|
            file.write(resp.body)
          }
        }
      end
    rescue
    end
  end
  
  def resize(path)
    require 'rubygems'
    require 'mini_magick'
    begin
      image = MiniMagick::Image.from_file(path) 
      image.resize '270x410' 
      image.write(path.to_s)
    rescue 
      nil
    end
  end
  
end