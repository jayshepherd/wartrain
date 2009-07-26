class Movie < ActiveRecord::Base
  
  # Includes and contants
  require 'lib/art'
  include Art
  DEFAULT_POSTER = 'art/movies/default.jpg'
  
  # Associations
  has_many :assets, :as => :playable, :after_remove => :delete_empty_movie
  has_and_belongs_to_many :genres
  
  # Callbacks
  before_create :populate_imdb_id
  before_create :populate_metadata
  before_save :populate_sort_title
  after_save :build_playlist
  
  # Virtual Attributes
  def url
    paths = ''
    assets.each {|a| paths<<a.path}
    if paths.scan('/VIDEO_TS/').length > 0 then
      return assets.first.directory.nmt_path+
             assets.first.path.gsub(assets.first.path.split('/').last, '').chop
    else
      if assets.length == 1 then
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
    
    if (paths.upcase.scan('/VIDEO_TS/').length > 0) or (paths.upcase.scan(".ISO").length > 0) then
      # TVID="Play" name="Play" zcd="2" vod=""
      @html_options = {:vod => "", :zcd => "2"}
    else
      if assets.length == 1 then
        @html_options = {:vod => ""}
      else
        @html_options = {:vod => "playlist"}
      end
    end
    return @html_options
  end
  
  def poster
    path = Rails.root.join("public/art/movies",id.to_s+'.jpg')
    if File.exists?(path) : "/art/movies/"+id.to_s+'.jpg' else DEFAULT_POSTER end
  end
  
  # Public Instance Methods
  def populate_metadata
    require 'imdb'
    require 'json'
    
    if imdb_id.nil? : populate_imdb_id end
    unless imdb_id.nil?
      @imdb_entry = Imdb::Movie.new(imdb_id)
      # Update release date
      if release_date.nil? : self.release_date = @imdb_entry.release_date end
    end
    # Update poster
    if poster = DEFAULT_POSTER : update_poster(nil) end
  end
  
  def update_poster(url)
    if url.nil? : url = google_art(title+' movie poster') end
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
    
    def populate_imdb_id 
      debugger
      require 'imdb'
      begin
        @imdb_entry = Imdb::Search.new(title)
        unless @imdb_entry.movies.empty?
          self.imdb_id = @imdb_entry.movies.first.id 
        end
      rescue NoMethodError
        # do nothing... problem with Imdb::Search returning nils
      end
    end
    
    def populate_sort_title
      if self.title_changed?
        self.sort_title = self.title
        if self.title.index('The ') == 0 : self.sort_title = self.title.gsub('The ', '') end
        if self.title.index('A ') == 0 : self.sort_title = self.title.gsub('A ', '') end
        if self.title.index('An ') == 0 : self.sort_title = self.title.gsub('An ', '') end
      end
    end
    
    def delete_empty_movie
      if assets.empty? : self.delete end
    end
end
