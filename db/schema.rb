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

ActiveRecord::Schema[8.2].define(version: 2026_10_14_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "omen_status", ["unstarted", "started", "completed", "failed"]

  create_table "agents", force: :cascade do |t|
    t.citext "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_agents_on_email", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "phone", null: false
    t.string "email"
    t.string "name"
    t.string "surname"
    t.string "pin", limit: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_contacts_on_phone", unique: true
  end

  create_table "omen_answers", force: :cascade do |t|
    t.jsonb "content", default: [], null: false
    t.json "result", default: [], null: false
    t.jsonb "provenance", default: {}, null: false
    t.integer "input_usage", default: 0, null: false
    t.integer "output_usage", default: 0, null: false
    t.bigint "question_id", null: false
    t.string "stop_reason"
    t.string "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_omen_answers_on_question_id", unique: true
  end

  create_table "omen_questions", force: :cascade do |t|
    t.jsonb "content", default: [], null: false
    t.bigint "reading_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reading_id"], name: "index_omen_questions_on_reading_id"
  end

  create_table "omen_readings", force: :cascade do |t|
    t.string "type"
    t.enum "status", default: "unstarted", null: false, enum_type: "omen_status"
    t.integer "input_usage", default: 0, null: false
    t.integer "output_usage", default: 0, null: false
    t.bigint "agent_id", null: false
    t.integer "questions_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_omen_readings_on_agent_id"
    t.index ["type"], name: "index_omen_readings_on_type"
  end

  add_foreign_key "omen_answers", "omen_questions", column: "question_id"
  add_foreign_key "omen_questions", "omen_readings", column: "reading_id"
  add_foreign_key "omen_readings", "agents"
end
