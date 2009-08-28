class AddWatchedToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :watched, :boolean  
  end

  def self.down
    remove_column :contents, :watched
  end
end
