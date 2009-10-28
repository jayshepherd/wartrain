class AddPromotionIDtoContentTable < ActiveRecord::Migration
  def self.up
    add_column :contents, :promotion_id, :integer
  end

  def self.down
    remove_column :contents, :promotion_id
  end
end
