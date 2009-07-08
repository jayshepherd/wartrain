class Movie < ActiveRecord::Base
  has_many :assets, :as => :playable
  
  after_save :build_playlist
  
  private
    def build_playlist
      file = File.new(Rails.root.join("public/playlists/movies",id.to_s+".jsp"), "w")
        #debugger
        sorted_assets = assets.find(:all, :order => 'path ASC')
        sorted_assets.each do |asset|
          file.puts (title+"|0|0|"+asset.directory.nmt_path+
                     asset.path+"|")
        end
      file.close
    end
end
