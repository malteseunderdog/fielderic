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

ActiveRecord::Schema.define(:version => 201201140003109) do

  create_table "field", :force => true do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.boolean  "organiser"
    t.datetime "joined"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match", :force => true do |t|
    t.datetime "created"
    t.datetime "kickoff"
    t.string   "location"
    t.string   "variety"
    t.integer  "required"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player", :force => true do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "password"
    t.string   "location"
    t.datetime "registration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
