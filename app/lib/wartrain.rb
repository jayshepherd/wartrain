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
     debugger
     require 'imdb'
     if movie.imdb_id.nil? : fetch_imdb_id(movie) end
     unless movie.imdb_id.nil?
       entry = Imdb::Movie.new(movie.imdb_id)
       if movie.release_date.nil? : movie.release_date = entry.release_date end
       unless File.exists?(Rails.root.join("public/art/movies",movie.id.to_s+'.jpg'))
         save_url(entry.poster, Rails.root.join("public/art/movies",movie.id.to_s+'.jpg'))
       end
     end
   end
  
   def self.save_url(url, path)
     require 'net/http'
     
     server = url.split('/').third
     remote_path = url.gsub(server, '')
     
     Net::HTTP.start(server) { |http|
       resp = http.get(remote_path)
       open( path, 'w' ) { |file|
         file.write(resp.body)
       }
     }
   end
   
end