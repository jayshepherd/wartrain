class RemoveTimerFromDirectories < ActiveRecord::Migration
  def self.up
    remove_column :directories, :timer
  end

  def self.down
    add_column :directories, :timer, :integer
  end
end
