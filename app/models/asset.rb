class Asset < ActiveRecord::Base
  belongs_to :content
  belongs_to :directory
  belongs_to :asset_type
  
  validate :file_must_exist
  
  after_create :create_content
  
  def to_label # for ActiveScaffold
    path
  end
  
  private
  
    def file_must_exist 
      errors.add(:path, 'must exist') unless
        File.exist?(directory.physical_path+path)
    end 
    
    def create_content
      case directory.content_type.name
        when 'Movies'
          title = path.split('/').first.split('(').first
          movie = Movie.find_or_initialize_by_title(:title => title)
            movie.assets<<self
          movie.save
      end
    end
    
end