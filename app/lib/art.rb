module Art
   
   def self.update_art(url, id, type)   
     path = Rails.root.join("public/art/"+type.to_s.pluralize,id.to_s+'.jpg')
     save_url(url, path) unless url.nil? 
     resize(path) if File.exists?(path)
   end

private 

  def self.save_url(url, path)
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
  
  def self.resize(path)
    require 'rubygems'
    require 'mini_magick'
    image = MiniMagick::Image.from_file(path)
    image.write(path.to_s)
    image.resize '270x410' 
    image.write(path.to_s.gsub('.jpg','l.jpg'))
    image.resize '192x298'
    image.write(path.to_s.gsub('.jpg','m.jpg'))
    image.resize '178x271'
    image.write(path.to_s.gsub('.jpg','s.jpg'))
  end
  
end