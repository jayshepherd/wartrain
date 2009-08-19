class FixDirectoryColumns < ActiveRecord::Migration
  def self.up
    rename_column :directories, :local_path, :physical_path
    rename_column :directories, :type, :content_type
  end

  def self.down
    rename_column :directories, :content_type, :type
    rename_column :directories, :physical_path, :local_path
  end
end
