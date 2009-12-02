class CreateContentTypesTable < ActiveRecord::Migration
  def self.up
    create_table :content_types do |t|
        t.string :name
    end
  end

  def self.down
    drop_table :content_types
  end
end
