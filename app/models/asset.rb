class Asset < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :directory
end