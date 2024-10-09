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

ActiveRecord::Schema[7.0].define(version: 2024_10_06_065722) do
  create_table "comments", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "rally_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rally_id"], name: "index_comments_on_rally_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "missions", charset: "utf8", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rallies", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "abstract", null: false
    t.text "background"
    t.text "idea"
    t.text "method"
    t.text "result"
    t.text "discussion"
    t.text "conclusion", null: false
    t.text "opinion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rallies_on_user_id"
  end

  create_table "user_missions", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mission_id", null: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_user_missions_on_mission_id"
    t.index ["user_id"], name: "index_user_missions_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "rallies", "users"
end
