# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141006214829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "documents", force: true do |t|
    t.text     "title"
    t.text     "supertitle"
    t.text     "subtitle"
    t.text     "callout"
    t.text     "body"
    t.text     "footer"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "parent_id"
    t.boolean  "scraped",    default: false, null: false
  end

  create_table "events", force: true do |t|
    t.datetime "time"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venue_id"
  end

  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "events_series", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "series_id"
  end

  create_table "images", force: true do |t|
    t.text     "alt"
    t.text     "title"
    t.text     "source_url"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "street_address"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
  end

end
