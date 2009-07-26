class RenameExtensionToRegex < ActiveRecord::Migration
  def self.up
    rename_column :asset_types, :extension, :regex
  end

  def self.down
    rename_column :asset_types, :regex, :extension
  end
end
