# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091027042032) do

  create_table "asset_types", :force => true do |t|
    t.string   "name"
    t.string   "regex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asset_types_directories", :id => false, :force => true do |t|
    t.integer "asset_type_id"
    t.integer "directory_id"
  end

  create_table "assets", :force => true do |t|
    t.string   "path"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_type_id"
    t.integer  "directory_id"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.date     "release_date"
    t.string   "imdb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_title"
    t.string   "type"
    t.boolean  "watched"
    t.integer  "promotion_id"
  end

  create_table "contents_genres", :id => false, :force => true do |t|
    t.integer  "genre_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directories", :force => true do |t|
    t.string   "physical_path"
    t.string   "nmt_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "digest"
    t.string   "content_type"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotions", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
