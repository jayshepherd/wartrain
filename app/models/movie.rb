class Movie < Content
  KEY = '1d458d21d26c0b91de5a7b6f2cffe795'
  
  # Callbacks
  after_create :populate_metadata

  # Public Instance Methods
  def populate_metadata
    require 'tmdb_party'
    tmdb = TMDBParty::Base.new(KEY)
    
    if tmdb_id.nil?
      results = tmdb.search(title)
      self.tmdb_id = results.first.id unless results.empty?
    end
    
    unless tmdb_id.nil?
      begin
        tmdb_movie = tmdb.get_info(tmdb_id)
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
        debugger
        update_poster(nil) if poster == '/art/default.jpg'
      end
    end
    self.save
  end
  
  def update_poster(url)
    debugger
    require 'tmdb_party'
    require 'lib/art'
    
    if url.blank?
      tmdb = TMDBParty::Base.new(KEY)
      tmdb_movie = tmdb.get_info(tmdb_id)
      url = tmdb_movie.posters.first["cover"] unless tmdb_movie.posters.empty?
    end
    update_art(url, self.id) unless url.blank?
  end
    
end