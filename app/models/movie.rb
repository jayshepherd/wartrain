class Movie < ActiveRecord::Base
  
  # Associations
  has_many :assets, :as => :playable
  
  # Callbacks
  before_create :fetch_imdb_id
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
  
  def vod_tag
    #debugger
    paths = ''
    assets.each {|a| paths<<a.path}
    if paths.scan('/VIDEO_TS/').length < 1 and assets.length > 1 then
      return 'playlist'
    else
      return ''
    end
  end
  
  # Private Helper Methods
  private
  
    def build_playlist
      sorted_assets = assets.find(:all, :order => 'path ASC')
      paths = ''
      assets.each {|a| paths<<a.path}
      if sorted_assets.length > 1 and paths.scan('/VIDEO_TS/').length == 0
        file = File.new(Rails.root.join("public/playlists/movies",id.to_s+".jsp"), "w")
          sorted_assets.each_with_index do |asset, idx|
            file.puts(title+idx.to_s+"|0|0|"+asset.directory.nmt_path+asset.path+"|")
          end
        file.close
      end
    end
    
    def fetch_imdb_id
      require 'imdb'
      begin
        entry = Imdb::Search.new(title)
        unless entry.movies.first.id == nil
          self.imdb_id = entry.movies.first.id
          # redirect_to :controller => :movie, :action => :fetch_metadata, :id => id
        end
      rescue NoMethodError
        # do nothing... problem with Imdb::Search returning nils
      end
    end
    
end
