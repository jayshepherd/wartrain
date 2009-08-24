class Movie < Content
  
  # Associations
  has_and_belongs_to_many :genres
  
  # Callbacks
  after_create :populate_metadata

  # Public Instance Methods
  def populate_metadata
    require 'imdb'
    require 'json'

    begin
      if imdb_id.nil?
        @imdb_search = Imdb::Search.new(title)
        self.imdb_id = @imdb_search.movies.first.id unless @imdb_search.movies.empty?
      end
    
      unless imdb_id.nil?
        @imdb_entry = Imdb::Movie.new(imdb_id)
    
        # Update release date
        self.release_date = @imdb_entry.release_date if release_date.nil?
    
        # Update genres
        @imdb_entry.genres.each do |genre|
          @genre = Genre.find_or_create_by_name(genre)
          self.genres<<@genre
        end
      end
      # Update poster
      update_poster(nil) if poster == DEFAULT_POSTER
      self.save!
    rescue
    end
  end
    
end