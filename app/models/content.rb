class Content < ActiveRecord::Base
  # Includes and contants
  require 'lib/art'
  include Art
  
  # Associations
  has_many :assets, :after_remove => :delete_empty_content
  has_and_belongs_to_many :genres
  
  # Callbacks
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
        return '/playlists/'+id.to_s+'.jsp'
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
    path = Rails.root.join("public/art",id.to_s+'.jpg')
    if File.exists?(path)
       "/art/"+id.to_s+".jpg"
    else
       "/art/default.jpg"
    end
  end
  
  def update_poster(url)
    url = google_art(title+' '+type+' poster') if url.nil?
    update_art(url, Rails.root.join("public/art",id.to_s+'.jpg'))
  end
  
  # Private Instance Methods
  private
  
    def populate_sort_title
      if self.title_changed?
        self.sort_title = self.title
        self.sort_title = self.title.gsub('The ', '') if self.title.index('The ') == 0
        self.sort_title = self.title.gsub('A ', '')  if self.title.index('A ') == 0  
        self.sort_title = self.title.gsub('An ', '') if self.title.index('An ') == 0   
      end
    end
   
    def build_playlist
      sorted_assets = self.assets.find(:all, :order => "path ASC")
      paths = ''
      self.assets.each {|a| paths<<a.path}
      if sorted_assets.length > 1 and paths.scan("/VIDEO_TS/").length == 0
        file = File.new(Rails.root.join("public/playlists",id.to_s+".jsp"), "w")
          sorted_assets.each_with_index do |asset, idx|
            file.puts(title+idx.to_s+"|0|0|"+asset.directory.nmt_path+asset.path+"|")
          end
        file.close
      end
    end
    
    def delete_poster
       path = Rails.root.join("public/art",id.to_s+'.jpg')
       File.delete(path) if File.exists?(path) 
    end
    
    def delete_empty_content
      self.delete if assets.empty?
    end
    
end