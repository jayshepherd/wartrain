class Directory < ActiveRecord::Base
  has_many :assets
  has_and_belongs_to_many :asset_types
  
  def to_label
    self.physical_path
  end
end