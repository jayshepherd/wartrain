class RenamePlayableIDtoContentId < ActiveRecord::Migration
  def self.up
    rename_column :assets, :playable_id, :content_id
    remove_column :assets, :playable_type
  end

  def self.down
    rename_column :assets, :content_id, :playable_id
    add_column :assets, :playable_type, :string
  end
end
