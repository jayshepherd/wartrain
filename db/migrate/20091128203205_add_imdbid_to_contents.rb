class AddImdbidToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :imdb_id, :string
  end

  def self.down
    remove_column :contents, :imdb_id
  end
end
