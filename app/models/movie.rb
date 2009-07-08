class Movie < ActiveRecord::Base
  # Associations
  has_many :assets, :as => :playable
  
  # Callbacks
  before_create :fetch_imdb_id
  after_save :build_playlist
  
  # 
  private
    def build_playlist
      file = File.new(Rails.root.join("public/playlists/movies",id.to_s+".jsp"), "w")
        sorted_assets = assets.find(:all, :order => 'path ASC')
        sorted_assets.each do |asset|
          file.puts(title+"|0|0|"+asset.directory.nmt_path+asset.path+"|")
        end
      file.close
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
