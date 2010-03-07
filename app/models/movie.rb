class Movie < Content
  # themoviedb.org API key
  KEY = '1d458d21d26c0b91de5a7b6f2cffe795'
  
  after_create :populate_metadata

  def populate_metadata
    require 'tmdb_party'
    require 'imdb'
    
    if imdb_id.nil?
      @imdb_search = Imdb::Search.new(title)
      begin
        self.imdb_id = @imdb_search.movies.first.id unless @imdb_search.movies.empty?
      rescue
        nil
      end
    end
    
    unless imdb_id.nil?
      tmdb = TMDBParty::Base.new(KEY)
      begin
        tmdb_movie = tmdb.imdb_lookup('tt'+imdb_id)
      rescue
      end
      
      unless tmdb_movie.nil?
        tmdb_movie.get_info!
      
        # Update release date and trailer
        self.release_date = tmdb_movie.released
        self.trailer = tmdb_movie.trailer
        self.description = tmdb_movie.overview
        self.running_time = tmdb_movie.runtime
      
        # Update genres
        tmdb_movie.genres.each do |genre|
          @genre = Genre.find_or_create_by_name(genre.name)
          self.genres<<@genre
        end
  
        # Update art
        update_poster(nil) unless File.exists?("#{RAILS_ROOT}/public/art/posters/#{posters[:main]}")
        update_background(nil) unless File.exists?("#{RAILS_ROOT}/public/art/backgrounds/#{background}")
      end
    end
    self.save!
  end
  
  def update_poster(url)
    require 'tmdb_party'
    require 'lib/art'
    
    if url.blank?
      tmdb = TMDBParty::Base.new(KEY)
      begin
        tmdb_movie = tmdb.imdb_lookup('tt'+imdb_id)
      rescue
      end
      url = tmdb_movie.posters.first['cover'] unless tmdb_movie.posters.empty?
    end
    Art.update_art(self, url, :poster) unless url.blank?
  end
  
  def update_background(url)
    require 'tmdb_party'
    require 'lib/art'
    
    if url.blank?
      tmdb = TMDBParty::Base.new(KEY)
      begin
        tmdb_movie = tmdb.imdb_lookup('tt'+imdb_id)
      rescue
      end
      url = tmdb_movie.backdrops.first['original'] unless tmdb_movie.backdrops.empty?
    end
    Art.update_art(self, url, :background) unless url.blank?
  end
  
end