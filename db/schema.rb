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

ActiveRecord::Schema.define(version: 20131023015347) do

  create_table "exhibition_pieces", force: true do |t|
    t.string   "slug"
    t.string   "uuid"
    t.integer  "exhibition_id"
    t.string   "piece_type"
    t.integer  "piece_id"
    t.integer  "sort_index",         default: 9999
    t.integer  "section_id"
    t.integer  "section_sort_index", default: 9999
    t.boolean  "active",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exhibition_pieces", ["slug", "piece_type", "piece_id"], name: "index_exhibition_pieces_on_slug_and_piece_type_and_piece_id", unique: true, using: :btree
  add_index "exhibition_pieces", ["uuid"], name: "index_exhibition_pieces_on_uuid", unique: true, using: :btree

  create_table "exhibition_users", force: true do |t|
    t.integer  "exhibition_id"
    t.integer  "user_id"
    t.integer  "permission_level", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibitions", force: true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "subtitle"
    t.string   "excerpt"
    t.text     "description"
    t.string   "theme"
    t.datetime "publish_at"
    t.datetime "unpublish_at"
    t.boolean  "option_glass",           default: false
    t.boolean  "option_playable",        default: true
    t.boolean  "option_wifi_restricted", default: false
    t.boolean  "active",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exhibitions", ["slug"], name: "index_exhibitions_on_slug", unique: true, using: :btree

  create_table "piece_page_events", force: true do |t|
    t.integer  "piece_page_id"
    t.integer  "action_type",    default: 0
    t.integer  "action_timeout", default: 0
    t.string   "action_array"
    t.text     "action_text"
    t.integer  "sort_index",     default: 9999
    t.boolean  "active",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piece_page_events", ["piece_page_id"], name: "index_piece_page_events_on_piece_page_id", using: :btree

  create_table "piece_pages", force: true do |t|
    t.string   "slug"
    t.text     "url"
    t.string   "wayback_url"
    t.datetime "wayback_date"
    t.string   "cache_page_file_name"
    t.integer  "cache_page_file_size"
    t.string   "cache_page_content_type"
    t.string   "cache_page_updated_at"
    t.date     "timeline_date"
    t.integer  "timeline_year"
    t.string   "title"
    t.string   "excerpt"
    t.text     "description"
    t.string   "author"
    t.string   "organization"
    t.string   "focus_position"
    t.string   "focus_keywords"
    t.boolean  "option_glass",            default: false
    t.boolean  "option_clickable",        default: true
    t.boolean  "active",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piece_pages", ["slug"], name: "index_piece_pages_on_slug", unique: true, using: :btree

  create_table "piece_texts", force: true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.integer  "position"
    t.string   "theme"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piece_texts", ["slug"], name: "index_piece_texts_on_slug", unique: true, using: :btree

  create_table "piece_thumbnails", force: true do |t|
    t.integer  "piece_id"
    t.string   "piece_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.integer  "exhibition_id"
    t.string   "slug"
    t.string   "title"
    t.string   "subtitle"
    t.string   "excerpt"
    t.text     "description"
    t.integer  "sort_index",    default: 9999
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["exhibition_id"], name: "index_sections_on_exhibition_id", using: :btree
  add_index "sections", ["slug"], name: "index_sections_on_slug", unique: true, using: :btree

end
