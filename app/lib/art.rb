module Art
   
   def self.update_art(content, url, type)
     path = "#{RAILS_ROOT}/public"
     case type
       when :poster 
         path += content.posters[:main]
       when 
         path += content.background
     end
     save_url(url, path) unless url.nil? 
     case type
       when :poster 
         resize(content.posters) if File.exists?(path)
     end
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
  
  def self.resize(posters)
    require 'RMagick'
    include Magick
    
    begin
      img = Magick::Image.read("#{RAILS_ROOT}/public"+posters[:main]).first
    
      thumb = img.resize_to_fit(300, 450)
      thumb.write "#{RAILS_ROOT}/public"+posters[:main]
    
      thumb = img.resize_to_fit(165, 248)
      thumb.write "#{RAILS_ROOT}/public"+posters[:medium]
    
      thumb = img.resize_to_fit(150, 225)
      thumb.write "#{RAILS_ROOT}/public"+posters[:small]
    
      img = Magick::Image.read("#{RAILS_ROOT}/public/art/posters/blank.png").first
      overlay = Magick::Image.read("#{RAILS_ROOT}/public"+posters[:small]).first
      img.composite!(overlay, CenterGravity, MultiplyCompositeOp)
      img.write "#{RAILS_ROOT}/public"+posters[:small]
    rescue
      nil
    end
  end
  
end