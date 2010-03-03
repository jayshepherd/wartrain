class AddTrailerToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :trailer, :string
  end

  def self.down
    remove_column :contents, :trailer
  end
end
