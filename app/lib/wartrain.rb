module WarTrain
  
  def self.fetch_imdb_id(movie)
     require 'imdb'
     begin
       entry = Imdb::Search.new(movie.title)
       unless entry.movies.empty?
         movie.imdb_id = entry.movies.first.id
       end
     rescue NoMethodError
       # do nothing... problem with Imdb::Search returning nils
     end
   end

   def self.fetch_metadata(movie)
     require 'imdb'
     if movie.imdb_id.nil? : fetch_imdb_id(movie) end
     unless movie.imdb_id.nil?
       entry = Imdb::Movie.new (movie.imdb_id)
       # Update release date
       if movie.release_date.nil? : movie.release_date = entry.release_date end
     end
     # Get Google URL
     url = google_poster (movie.title+' poster') # entry.poster
     # Update poster
     path = Rails.root.join('public/art/movies',movie.id.to_s+'.jpg')
     unless File.exists?(path) : update_poster(url, path) end
   end
   
   def self.update_poster(url, path)
     unless url.nil? : save_url(url, path) end
     if File.exists?(path) : resize_poster(path) end
   end
   
   def self.save_url(url, path)
     require 'net/http'
     url = url.gsub('http://', '')
     server = url.split('/').first
     remote_path = url.gsub(server, '')
     
     Net::HTTP.start (server) { |http|
       resp = http.get(remote_path)
       open( path, 'w' ) { |file|
         file.write(resp.body)
       }
     }
   end
   
   def self.resize_poster (path)
     require 'rubygems'
     require 'mini_magick'
     image = MiniMagick::Image.from_file(path)
     image.resize "270x410"
     image.write(path.to_s)
   end
  
   # Based on 
   # http://www.swards.net/2009/04/google-image-search-in-rails-using.html
   def self.google_poster (keyword)
     require 'json'
     url = "http://ajax.googleapis.com/ajax/services/search/images?sz=large&q=#{CGI.escape(keyword)}&v=1.0"
     json_results = open(url) {|f| f.read };
     results = JSON.parse(json_results)
     image_array = results['responseData']['results']
     image = image_array[0] if image_array
     return image['unescapedUrl']
   end
   
end