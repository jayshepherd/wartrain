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
      if directory.content_type == 'Movies'
          title = path.split('/').first.split('(').first
          movie = Movie.find_or_initialize_by_title(:title => title)
            movie.assets<<self
          movie.save
      end
    end
    
end