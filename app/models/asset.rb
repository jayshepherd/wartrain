class Asset < ActiveRecord::Base
  # Relations
  belongs_to :playable, :polymorphic => true
  belongs_to :directory
  belongs_to :asset_type
  
  # Validations
  validate :file_must_exist
  
  # Callbacks
  after_create :create_content
  
  # Other
  def to_label
    path
  end
  
  protected 
    def file_must_exist 
      errors.add(:path, 'must exist') unless
        File.exist?(directory.physical_path+path)
    end 
    
    def create_content
      debugger
      if directory.content_type == 'Movies'
        # Check if the asset has 'siblings'
        #entries = Dir.entries(File.dirname(directory.physical_path+path))
        #if entries.count > 3 
          #entries.each do |entry|
            #unless entry == '.' or entry == '..' 
              #sibling = Asset.find_by_path(entry.gsub(directory.physical_path))
              #unless sibling == nil : @movie = sibling.movie end
              #end
            #end
          #if @movie == nil : Movie.find_or_create_by_title(:title => @title) end
        #else
          @movie = Movie.find_or_create_by_title(:title => path.split('/').first)
        #end
        @movie.assets<<self
      end
    end
    
end