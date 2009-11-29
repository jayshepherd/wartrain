module Art
   
   def self.update_art(url, id, type)
     debugger
     path = Rails.root.join("public/art/"+type.to_s.pluralize,id.to_s+'.jpg')
     save_url(url, path) unless url.nil? 
     resize(path) if File.exists?(path)
   end

private 

  def self.save_url(url, path)
    require 'net/http'
    begin
      debugger
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
  
  def self.resize(path)
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