class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :path
      t.string :directory_id
      t.integer :playable_id
      t.string :playable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
