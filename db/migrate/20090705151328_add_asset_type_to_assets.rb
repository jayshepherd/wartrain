class AddAssetTypeToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :asset_type_id, :integer
  end

  def self.down
    remove_column :assets, :asset_type_id
  end
end
