class AssetType < ActiveRecord::Base
  
  # Associations
  has_many :assets
  has_and_belongs_to_many :directories 
  
end
