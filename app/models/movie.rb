class Movie < Content
  KEY = '1d458d21d26c0b91de5a7b6f2cffe795'
  
  # Callbacks
  after_create :populate_metadata

  # Public Instance Methods
  def populate_metadata
    require 'tmdb_party'
    require 'imdb'
    
    if imdb_id.nil?
      @imdb_search = Imdb::Search.new(title)
      self.imdb_id = @imdb_search.movies.first.id unless @imdb_search.movies.empty?
    end
    
    unless imdb_id.nil?
      tmdb = TMDBParty::Base.new(KEY)
      begin
        tmdb_movie = tmdb.imdb_lookup('tt'+imdb_id)
      rescue
      end
      
      unless tmdb_movie.nil?
        tmdb_movie.get_info!
      
        # Update release date
        self.release_date = tmdb_movie.released
      
        # Update genres
        tmdb_movie.genres.each do |genre|
          @genre = Genre.find_or_create_by_name(genre.name)
          self.genres<<@genre
        end
    
        # Update poster
        update_poster(nil) if poster == '/art/posters/default .png'
      end
    end
    self.save
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
      url = tmdb_movie.posters.first["cover"] unless tmdb_movie.posters.empty?
    end
    Art.update_art(url, self.id, :poster) unless url.blank?
  end
    
end