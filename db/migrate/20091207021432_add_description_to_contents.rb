class AddDescriptionToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :description, :string
  end

  def self.down
    remove_column :contents, :description
  end
end
