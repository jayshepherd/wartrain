module Art
   
   def self.update_art(content, url)   
     path = "#{RAILS_ROOT}/public"+content.posters[:main]
     save_url(url, path) unless url.nil? 
     resize(content.posters) if File.exists?(path)
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
    
    img = Magick::Image.read("#{RAILS_ROOT}/public"+posters[:main]).first
    
    thumb = img.resize_to_fit(300, 450)
    thumb.write "#{RAILS_ROOT}/public"+posters[:main]
    
    thumb = img.resize_to_fit(110, 165)
    thumb.write "#{RAILS_ROOT}/public"+posters[:medium]
    
    thumb = img.resize_to_fit(100, 150)
    thumb.write "#{RAILS_ROOT}/public"+posters[:small]
    
    img = Magick::Image.read("#{RAILS_ROOT}/public/art/posters/blank.png").first
    overlay = Magick::Image.read("#{RAILS_ROOT}/public"+posters[:small]).first
    img.composite!(overlay, CenterGravity, MultiplyCompositeOp)
    img.write "#{RAILS_ROOT}/public"+posters[:small]
  end
  
end