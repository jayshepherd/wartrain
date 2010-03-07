class AddRunningTimeToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :running_time, :integer
  end

  def self.down
    remove_column :contents, :running_time
  end
end
