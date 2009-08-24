class RenameMoviesTableToContent < ActiveRecord::Migration
  def self.up
    rename_table :movies, :contents
    add_column :contents, :type, :string
  end

  def self.down
    remove_column :contents, :type
    rename_table :contents, :movies
  end
end
