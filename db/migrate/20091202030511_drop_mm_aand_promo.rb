class DropMmAandPromo < ActiveRecord::Migration
  def self.up
    drop_table :promotions
  end

  def self.down
  end
end
