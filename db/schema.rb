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

ActiveRecord::Schema.define(version: 20131129224704) do

  create_table "innings", force: true do |t|
    t.string   "matchname"
    t.string   "inningsname"
    t.decimal  "hashkey"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "numbats"
    t.integer  "numbowls"
    t.integer  "numfields"
    t.integer  "match_id"
    t.date     "date"
  end

  add_index "innings", ["hashkey"], name: "index_innings_on_hashkey", unique: true, using: :btree

  create_table "matches", force: true do |t|
    t.string   "matchname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "hashkey"
    t.integer  "mom"
    t.date     "date"
  end

  add_index "matches", ["hashkey"], name: "index_matches_on_hashkey", unique: true, using: :btree

  create_table "player_scores", force: true do |t|
    t.string   "name"
    t.integer  "match_id"
    t.integer  "innings_id"
    t.integer  "bat_minutes"
    t.string   "bat_how"
    t.integer  "bat_runs_scored"
    t.integer  "bat_balls"
    t.integer  "bat_fours"
    t.integer  "bat_sixes"
    t.decimal  "bat_sr"
    t.integer  "bowl_overs"
    t.integer  "bowl_maidens"
    t.integer  "bowl_runs"
    t.integer  "bowl_wickets"
    t.integer  "bowl_wides"
    t.integer  "bowl_noballs"
    t.decimal  "bowl_er"
    t.integer  "field_catches"
    t.integer  "field_stumpings"
    t.integer  "field_runouts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bat_not_outs"
    t.integer  "player_id"
    t.integer  "field_drops"
  end

  create_table "player_scores_teams", id: false, force: true do |t|
    t.integer "player_score_id"
    t.integer "team_id"
  end

  add_index "player_scores_teams", ["player_score_id"], name: "index_player_scores_teams_on_player_score_id", using: :btree
  add_index "player_scores_teams", ["team_id"], name: "index_player_scores_teams_on_team_id", using: :btree

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
    t.integer  "bat_score"
    t.integer  "bowl_score"
    t.integer  "field_score"
    t.integer  "bonus"
    t.float    "bat_avg"
    t.float    "bowl_avg"
    t.boolean  "bat_avg_invalid"
    t.boolean  "bowl_avg_invalid"
    t.integer  "total"
    t.integer  "bowl_maidens"
    t.integer  "bat_fours"
    t.integer  "bat_sixes"
    t.integer  "ts_increment"
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
    t.integer  "totalscore"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin"
    t.string   "remember_token"
    t.integer  "teamcash"
    t.integer  "totalscore"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
