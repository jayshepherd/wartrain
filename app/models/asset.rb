class Asset < ActiveRecord::Base
  
  # Associations
  belongs_to :content
  belongs_to :directory
  belongs_to :asset_type
  
  # Validations
  validate :file_must_exist
  
  # Callbacks
  after_create :create_content
  
  # Virtual Attributes
  def to_label # for ActiveScaffold
    path
  end
  
  private
  
    def file_must_exist 
      errors.add(:path, 'must exist') unless
        File.exist?(directory.physical_path+path)
    end 
    
    def create_content
      case directory.content_type
        when 'Movies'
          title = path.split('/').first.split('(').first
          movie = Movie.find_or_initialize_by_title(:title => title)
            movie.assets<<self
          movie.save
        when 'MMA Events'
          title = path.split('/').second
          mma_event = MmaEvent.find_or_initialize_by_title(:title => title)
            mma_event.assets<<self
          mma_event.save
      end
    end
    
end