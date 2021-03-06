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

ActiveRecord::Schema.define(version: 20160627151247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.integer  "en_passant_file"
    t.integer  "current_player",                    default: 0,     null: false
    t.string   "game_result"
    t.string   "game_over_reason"
    t.integer  "move_rule_count",                   default: 0
    t.boolean  "white_player_draw",                 default: false
    t.boolean  "black_player_draw",                 default: false
    t.string   "game_conceding_player"
  end

  create_table "pieces", force: :cascade do |t|
    t.integer "game_id"
    t.string  "piece_type", limit: 255
    t.string  "color",      limit: 255
    t.integer "x_coord"
    t.integer "y_coord"
    t.string  "img",        limit: 255
    t.boolean "moved",                  default: false
  end

  add_index "pieces", ["game_id"], name: "index_pieces_on_game_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "wins"
    t.integer  "losses"
    t.datetime "last_request_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
