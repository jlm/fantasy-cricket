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

ActiveRecord::Schema.define(version: 20140424203528) do

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
    t.string   "player_category"
    t.integer  "price"
    t.integer  "ts_keeper_decrement"
    t.integer  "ls_bat_innings"
    t.integer  "ls_bat_runs_scored"
    t.integer  "ls_bat_fours"
    t.integer  "ls_bat_sixes"
    t.integer  "ls_bat_fifties"
    t.integer  "ls_bat_hundreds"
    t.integer  "ls_bat_ducks"
    t.integer  "ls_bat_not_outs"
    t.integer  "ls_bowl_overs"
    t.integer  "ls_bowl_runs"
    t.integer  "ls_bowl_wickets"
    t.integer  "ls_bowl_4_wickets"
    t.integer  "ls_bowl_6_wickets"
    t.integer  "ls_bowl_maidens"
    t.integer  "ls_field_catches"
    t.integer  "ls_field_runouts"
    t.integer  "ls_field_stumpings"
    t.integer  "ls_field_drops"
    t.integer  "ls_field_mom"
    t.integer  "ls_bat_score"
    t.integer  "ls_bowl_score"
    t.integer  "ls_field_score"
    t.integer  "ls_bonus"
    t.integer  "ls_total"
    t.float    "ls_bat_avg"
    t.float    "ls_bowl_avg"
    t.boolean  "ls_bat_avg_invalid"
    t.boolean  "ls_bowl_avg_invalid"
    t.integer  "ls_price"
  end

  create_table "players_teams", id: false, force: true do |t|
    t.integer "team_id"
    t.integer "player_id"
  end

  add_index "players_teams", ["player_id"], name: "index_players_teams_on_player_id", using: :btree
  add_index "players_teams", ["team_id"], name: "index_players_teams_on_team_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "totalscore"
    t.integer  "captain_id"
    t.boolean  "validated"
    t.integer  "keeper_id"
    t.boolean  "never_validated"
  end

  create_table "tokens", force: true do |t|
    t.string   "tokenstr"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "realname"
    t.integer  "ticketno"
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
    t.boolean  "drop_available"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "tokenstr"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
