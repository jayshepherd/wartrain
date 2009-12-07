class Content < ActiveRecord::Base
 
  # Associations
  has_many :assets, :after_remove => :delete_empty_content
  has_and_belongs_to_many :genres
  
  # Callbacks
  before_save :populate_sort_title
  after_save :build_playlist
  after_destroy :delete_files
  
  # Virtual Attributes
  def url
    debugger
    paths = ''
    assets.each {|a| paths<<a.path}
    if paths['/VIDEO_TS/']
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
    debugger
    @html_options = Hash.new
    paths = ''
    assets.each {|a| paths<<a.path}
    
    if (paths.upcase.scan('/VIDEO_TS/').length > 0) or (paths.upcase.scan(".ISO").length > 0) or 
       (paths.upcase.scan(".IMG").length > 0)
      # TVID="Play" name="Play" zcd="2" vod=""
      @html_options.merge({:vod => "", :zcd => "2"})
    else   
      @html_options.merge(assets.length == 1 ? {:vod => ""} : {:vod => "playlist"})
    end
  end
  
  def posters
    @posters = {
      :main => "/art/posters/"+id.to_s+".jpg",
      :small => "/art/posters/"+id.to_s+"s.jpg",
      :medium => "/art/posters/"+id.to_s+"m.jpg"
    }
  end
  
  def background
    background = "/art/backgrounds/"+id.to_s+".jpg"
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
        file = File.new("#{RAILS_ROOT}/public/playlists/#{id.to_s}.jsp", "w")
          sorted_assets.each_with_index do |asset, idx|
            file.puts(title+idx.to_s+"|0|0|"+asset.directory.nmt_path+asset.path+"|")
          end
        file.close
      end
    end
    
    def delete_files
       path = "#{RAILS_ROOT}/public/art/posters/#{id.to_s}*.jpg"
       File.delete(path) if File.exists?(path) 
       path = "#{RAILS_ROOT}/public/playlists/#{id.to_s}.jsp"
       File.delete(path) if File.exists?(path)
    end
    
    def delete_empty_content
      self.delete if assets.empty?
    end
    
end