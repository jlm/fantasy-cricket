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

ActiveRecord::Schema.define(version: 20131024045127) do

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "age_category"
    t.integer  "bat_innings"
    t.integer  "bat_runs_scored"
    t.integer  "bat_fifties"
    t.integer  "bat_hundreds"
    t.integer  "bat_ducks"
    t.integer  "bat_not_outs"
    t.integer  "bowl_overs"
    t.integer  "bowl_runs"
    t.integer  "bowl_wickets"
    t.integer  "bowl_4_wickets"
    t.integer  "bowl_6_wickets"
    t.integer  "field_catches"
    t.integer  "field_runouts"
    t.integer  "field_stumpings"
    t.integer  "field_drops"
    t.integer  "field_mom"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team"
  end

  create_table "players_teams", id: false, force: true do |t|
    t.integer "team_id"
    t.integer "player_id"
  end

  add_index "players_teams", ["player_id"], name: "index_players_teams_on_player_id", using: :btree
  add_index "players_teams", ["team_id"], name: "index_players_teams_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
