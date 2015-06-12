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

ActiveRecord::Schema.define(version: 20150612080159) do

  create_table "inputs", force: true do |t|
    t.string "key",                              null: false
    t.float  "step",  limit: 24, default: 1.0,   null: false
    t.float  "min",   limit: 24, default: 0.0,   null: false
    t.float  "max",   limit: 24, default: 100.0, null: false
    t.float  "start", limit: 24, default: 0.0,   null: false
    t.string "unit"
    t.string "group"
  end

  add_index "inputs", ["group"], name: "index_inputs_on_group", using: :btree

  create_table "props", force: true do |t|
    t.string "key",       limit: 100, null: false
    t.string "behaviour", limit: 100, null: false
  end

  create_table "scenarios", force: true do |t|
    t.integer  "user_id"
    t.integer  "scene_id",                                       null: false
    t.integer  "session_id",                                     null: false
    t.integer  "beaglebone_id"
    t.string   "title"
    t.text     "input_values"
    t.datetime "updated_at"
    t.text     "query_results"
    t.float    "score",               limit: 24
    t.float    "total_co2_emissions", limit: 24
    t.float    "total_costs",         limit: 24
    t.float    "renewability",        limit: 24
    t.datetime "created_at"
    t.string   "guest_uid",           limit: 36
    t.integer  "end_year",                       default: 2030,  null: false
    t.string   "country",             limit: 2,  default: "nl",  null: false
    t.string   "guest_name",          limit: 50
    t.boolean  "obsolete",                       default: false
  end

  add_index "scenarios", ["session_id"], name: "index_scenarios_on_session_id", unique: true, using: :btree

  create_table "scene_inputs", force: true do |t|
    t.integer "scene_id",                   null: false
    t.integer "input_id",                   null: false
    t.string  "location",       limit: 100, null: false
    t.integer "position"
    t.float   "step",           limit: 24
    t.float   "min",            limit: 24
    t.float   "max",            limit: 24
    t.float   "start",          limit: 24
    t.text    "information_en"
    t.text    "information_nl"
  end

  add_index "scene_inputs", ["scene_id", "input_id"], name: "index_scene_inputs_on_scene_id_and_input_id", unique: true, using: :btree

  create_table "scene_props", force: true do |t|
    t.integer "scene_id",            null: false
    t.integer "prop_id",             null: false
    t.string  "location", limit: 50, null: false
    t.integer "position"
  end

  add_index "scene_props", ["scene_id", "prop_id"], name: "index_scene_props_on_scene_id_and_prop_id", unique: true, using: :btree

  create_table "scenes", force: true do |t|
    t.string "name",         limit: 100
    t.string "name_key",     limit: 100
    t.string "score_gquery"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean  "admin",                              default: false, null: false
    t.string   "name"
    t.string   "image"
    t.string   "origin"
    t.string   "token"
    t.string   "uid"
    t.string   "ip"
    t.string   "city"
    t.string   "country"
    t.float    "latitude",               limit: 24
    t.float    "longitude",              limit: 24
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
