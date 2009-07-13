class Movie < ActiveRecord::Base
  
  # Associations
  has_many :assets, :as => :playable
  
  # Callbacks
  before_create :populate_metadata
  after_save :build_playlist
  
  # Virtual Attributes
  def url
    paths = ''
    assets.each {|a| paths<<a.path}
    if paths.scan("/VIDEO_TS/").length > 0 then
      return assets.first.directory.nmt_path+
             assets.first.path.gsub(assets.first.path.split("/").last, "").chop
    else
      if assets.length == 1 then
        return assets.first.directory.nmt_path+assets.first.path
      else
        return "/playlists/movies/"+id.to_s+".jsp"
      end
    end
  end
  
  def html_options
    @html_options = Hash.new
    paths = ''
    assets.each {|a| paths<<a.path}
    
    if (paths.upcase.scan("/VIDEO_TS/").length > 0) or (paths.upcase.scan(".ISO").length > 0) then
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
    if File.exists?(path) : "/art/movies/"+id.to_s+'.jpg' else "/art/movies/default.jpg" end
  end
  
  # Private Helper Methods
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
    
    def populate_metadata
      require 'lib/wartrain'
      WarTrain.fetch_metadata(self)
    end
end
