class Movie < ActiveRecord::Base
  
  # Includes and contants
  require 'lib/art'
  include Art
  DEFAULT_POSTER = 'art/movies/default.jpg'
  
  # Associations
  has_many :assets, :as => :playable, :after_remove => :delete_empty_movie
  has_and_belongs_to_many :genres
  
  # Callbacks
  before_create :populate_metadata
  before_save :populate_sort_title
  after_save :build_playlist
  after_destroy :delete_poster
  
  # Virtual Attributes
  def url
    paths = ''
    assets.each {|a| paths<<a.path}
    if paths.scan('/VIDEO_TS/').length > 0 
      return assets.first.directory.nmt_path+
             assets.first.path.gsub(assets.first.path.split('/').last, '').chop
    else
      if assets.length == 1
        return assets.first.directory.nmt_path+assets.first.path
      else
        return '/playlists/movies/'+id.to_s+'.jsp'
      end
    end
  end
  
  def html_options
    @html_options = Hash.new
    paths = ''
    assets.each {|a| paths<<a.path}
    
    if (paths.upcase.scan('/VIDEO_TS/').length > 0) or (paths.upcase.scan(".ISO").length > 0)
      # TVID="Play" name="Play" zcd="2" vod=""
      @html_options = {:vod => "", :zcd => "2"}
    else   
      @html_options = (assets.length == 1 ? {:vod => ""} : {:vod => "playlist"})
    end
    return @html_options
  end
  
  def poster
    path = Rails.root.join("public/art/movies",id.to_s+'.jpg')
    File.exists?(path) ? "/art/movies/"+id.to_s+'.jpg' : DEFAULT_POSTER
  end

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
    rescue
    end
  end
  
  def update_poster(url)
    url = google_art(title+' movie poster') if url.nil?
    update_art(url, Rails.root.join("public/art/movies",id.to_s+'.jpg'))
  end
  
  # Private Instance Methods
  private
  
    def build_playlist
      sorted_assets = assets.find(:all, :order => "path ASC")
      paths = ''
      assets.each {|a| paths<<a.path}
      if sorted_assets.length > 1 and paths.scan("/VIDEO_TS/").length == 0
        file = File.new(Rails.root.join("public/playlists/movies",id.to_s+".jsp"), "w")
          sorted_assets.each_with_index do |asset, idx|
            file.puts(title+idx.to_s+"|0|0|"+asset.directory.nmt_path+asset.path+"|")
          end
        file.close
      end
    end
    
    def populate_sort_title
      if self.title_changed?
        self.sort_title = self.title
        self.sort_title = self.title.gsub('The ', '') if self.title.index('The ') == 0
        self.sort_title = self.title.gsub('A ', '')  if self.title.index('A ') == 0  
        self.sort_title = self.title.gsub('An ', '') if self.title.index('An ') == 0   
      end
    end
    
    def delete_empty_movie
      self.delete if assets.empty?
    end
    
    def delete_poster
       path = Rails.root.join("public/art/movies",id.to_s+'.jpg')
       File.delete(path) if File.exists?(path) 
    end
end