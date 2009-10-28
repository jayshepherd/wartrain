class RemovePkFromAssetTypeDirectories < ActiveRecord::Migration
  def self.up
    remove_column :asset_types_directories, :id
  end

  def self.down
    add_column :asset_types_directories, :id, :integer
  end
end
