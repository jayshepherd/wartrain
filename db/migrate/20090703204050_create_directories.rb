class CreateDirectories < ActiveRecord::Migration
  def self.up
    create_table :directories do |t|
      t.string :local_path
      t.string :nmt_path
      t.string :type
      t.integer :timer

      t.timestamps
    end
  end

  def self.down
    drop_table :directories
  end
end
