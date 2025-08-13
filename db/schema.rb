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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_164054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "family_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_family_groups_on_event_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "family_group_id"
    t.string "hash_id"
    t.index ["event_id"], name: "index_invitations_on_event_id"
    t.index ["family_group_id"], name: "index_invitations_on_family_group_id"
    t.index ["hash_id"], name: "index_invitations_on_hash_id", unique: true
  end

  create_table "lineas", force: :cascade do |t|
    t.bigint "presupuesto_id", null: false
    t.string "concepto", null: false
    t.integer "valor_cents", null: false
    t.string "valor_currency", default: "USD"
    t.boolean "por_persona", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["presupuesto_id"], name: "index_lineas_on_presupuesto_id"
  end

  create_table "presupuestos", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_presupuestos_on_event_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "family_groups", "events"
  add_foreign_key "invitations", "events"
  add_foreign_key "invitations", "family_groups"
  add_foreign_key "lineas", "presupuestos"
  add_foreign_key "presupuestos", "events"
  add_foreign_key "sessions", "users"
end
