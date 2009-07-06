class Directory < ActiveRecord::Base
  has_many :assets
  has_and_belongs_to_many :asset_types
end