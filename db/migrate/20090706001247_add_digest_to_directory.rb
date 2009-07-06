class AddDigestToDirectory < ActiveRecord::Migration
  def self.up
    add_column :directories, :digest, :string
  end

  def self.down
    remove_column :directories, :digest
  end
end
