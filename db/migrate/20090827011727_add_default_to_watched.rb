class AddDefaultToWatched < ActiveRecord::Migration
  def self.up
    remove_column :contents, :watched
    add_column :contents, :watched, :boolean, :default => 0
  end
  
  def self.down
    add_column :contents, :watched, :boolean
    remove_column :contents, :watched
  end
end
