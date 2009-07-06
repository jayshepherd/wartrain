class AddTypeToDirectory < ActiveRecord::Migration
  def self.up
    add_column :directories, :content_type, :string
  end

  def self.down
    remove_column :directories, :content_type
  end
end
