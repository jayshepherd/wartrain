module Art
   
   def self.update_art(url, id, type)   
     path = Rails.root.join("public/art/"+type.to_s.pluralize,id.to_s+' .png')
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
    debugger
    require 'RMagick'
    include Magick
    
    img = Magick::Image.read(path).first
    thumb = img.resize_to_fit(270, 410)
    thumb.write path.to_s.gsub(' .png','l .png')
    
    img = Magick::Image.read(path).first
    thumb = img.resize_to_fit(192, 298)
    thumb.write path.to_s.gsub(' .png','m .png')
    
    img = Magick::Image.read(path).first
    thumb = img.resize_to_fit(178, 271)
    thumb.write path.to_s.gsub(' .png','s .png')
    
    img = Magick::Image.read(Rails.root.to_s+'/public/art/posters/blank.png').first
    overlay = Magick::Image.read(path.to_s.gsub(' .png','s .png')).first
    img.composite!(overlay, CenterGravity, MultiplyCompositeOp)
    img.write(path.to_s.gsub(' .png','s .png'))
  end
  
end