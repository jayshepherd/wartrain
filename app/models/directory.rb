class Directory < ActiveRecord::Base
  # Associations
  has_many :assets
  has_and_belongs_to_many :asset_types
  
  # ActiveScaffold label
  def to_label
    self.physical_path
  end
end