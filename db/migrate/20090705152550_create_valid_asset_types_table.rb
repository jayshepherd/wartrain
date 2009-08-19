class CreateValidAssetTypesTable < ActiveRecord::Migration
  def self.up
    create_table :asset_types_directories do |t|
      t.integer :asset_type_id
      t.integer :directory_id
    end
  end

  def self.down
    drop_table :asset_types_directories
  end
end
