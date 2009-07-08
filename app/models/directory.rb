class Directory < ActiveRecord::Base
  
  # Associations
  has_many :assets
  has_and_belongs_to_many :asset_types
  
  # Virtual Attributes
  def to_label # for ActiveScaffold
    self.physical_path
  end

end