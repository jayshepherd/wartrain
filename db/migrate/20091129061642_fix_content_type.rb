class FixContentType < ActiveRecord::Migration
  def self.up
    remove_column :directories, :content_type
    add_column :directories, :content_type_id, :integer
  end

  def self.down
    remove_column :directories, :content_type_id
    add_column :directories, :content_type, :string
  end
end
