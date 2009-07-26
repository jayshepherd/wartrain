class Genre < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :movies
end
