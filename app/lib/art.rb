module Art
   
   def self.update_art(content, url, type)
     path = "#{RAILS_ROOT}/public"
     case type
       when :poster 
         path += content.posters[:main]
       when :background
         path += content.background
     end
     save_url(url, path) unless url.nil? 
     case type
       when :poster 
         resize(content.posters, :poster) if File.exists?(path)
       when :background
         resize(content.background, :background) if File.exists?(path)
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
  
  def self.resize(images, type)
    require 'RMagick'
    include Magick
    
    case
      when type = :poster
        begin
          img = Magick::Image.read("#{RAILS_ROOT}/public"+images[:main]).first
    
          thumb = img.resize_to_fit(300, 450)
          thumb.write "#{RAILS_ROOT}/public"+images[:main]
    
          thumb = img.resize_to_fit(165, 248)
          thumb.write "#{RAILS_ROOT}/public"+images[:medium]
    
          thumb = img.resize_to_fit(150, 225)
          thumb.write "#{RAILS_ROOT}/public"+images[:small]
    
          img = Magick::Image.read("#{RAILS_ROOT}/public/art/posters/blank.png").first
          overlay = Magick::Image.read("#{RAILS_ROOT}/public"+images[:small]).first
          img.composite!(overlay, CenterGravity, MultiplyCompositeOp)
          img.write "#{RAILS_ROOT}/public"+images[:small]
        rescue
          nil
        end
      when type = :background
        begin
          img = Magick::Image.read("#{RAILS_ROOT}/public"+images).first
          final = img.resize_to_fit(1920, 1080)
          final.write "#{RAILS_ROOT}/public"+images
        rescue
          nil
        end
      end
  end
  
end