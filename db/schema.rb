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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111123151829) do

  create_table "inputs", :force => true do |t|
    t.string  "key",                          :null => false
    t.float   "step",      :default => 1.0,   :null => false
    t.float   "min",       :default => 0.0,   :null => false
    t.float   "max",       :default => 100.0, :null => false
    t.float   "start",     :default => 0.0,   :null => false
    t.string  "unit"
    t.integer "remote_id",                    :null => false
  end

  create_table "scene_inputs", :force => true do |t|
    t.integer "scene_id",                     :null => false
    t.integer "input_id",                     :null => false
    t.boolean "placement", :default => false, :null => false
    t.integer "position",  :default => 0,     :null => false
  end

  create_table "scenes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
