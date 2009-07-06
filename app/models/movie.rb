class Movie < ActiveRecord::Base
  has_many :assets, :as => :playable
  
  after_save :build_playlist
  
  private
    def build_playlist
      file = File.new(Rails.root.join("public/playlists/movies",self.id.to_s+".jsp"), "w")
        self.videos.each do |video|
          file.puts (self.title+"|0|0|"+video.nmt_path+"|")
        end
      file.close
    end
end
