# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_18_233956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "couples", force: :cascade do |t|
    t.bigint "first_worker_id", null: false
    t.bigint "second_worker_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_worker_id", "second_worker_id", "game_id"], name: "index_couples_on_workers_and_game", unique: true
    t.index ["first_worker_id"], name: "index_couples_on_first_worker_id"
    t.index ["game_id"], name: "index_couples_on_game_id"
    t.index ["second_worker_id"], name: "index_couples_on_second_worker_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "year_game", null: false
    t.text "workers", default: [], array: true
    t.bigint "worker_without_play_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_without_play_id"], name: "index_games_on_worker_without_play_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workers", force: :cascade do |t|
    t.string "name", null: false
    t.string "year_in_work", default: "2023", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_workers_on_location_id"
  end

  add_foreign_key "couples", "games"
  add_foreign_key "couples", "workers", column: "first_worker_id"
  add_foreign_key "couples", "workers", column: "second_worker_id"
  add_foreign_key "games", "workers", column: "worker_without_play_id"
  add_foreign_key "workers", "locations"
end
