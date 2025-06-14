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

ActiveRecord::Schema[8.0].define(version: 2025_03_08_001713) do
  create_table "apartments", force: :cascade do |t|
    t.integer "block_id", null: false
    t.string "number", null: false
    t.decimal "rent_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_apartments_on_block_id"
  end

  create_table "billings", force: :cascade do |t|
    t.integer "contract_id", null: false
    t.date "billing_reference_date"
    t.date "rent_reference_date"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["contract_id"], name: "index_billings_on_contract_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "building_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_blocks_on_building_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.integer "landlord_id", null: false
    t.string "name"
    t.string "address_street"
    t.string "address_number"
    t.string "address_district"
    t.string "address_city"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_state", null: false
    t.index ["landlord_id"], name: "index_buildings_on_landlord_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer "billing_id", null: false
    t.string "description", null: false
    t.decimal "amount", null: false
    t.integer "charge_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_id"], name: "index_charges_on_billing_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "apartment_id", null: false
    t.integer "landlord_id", null: false
    t.integer "tenant_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["apartment_id"], name: "index_contracts_on_apartment_id"
    t.index ["landlord_id"], name: "index_contracts_on_landlord_id"
    t.index ["tenant_id"], name: "index_contracts_on_tenant_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
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
    t.integer "landlord_id"
    t.integer "role", default: 0, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["landlord_id"], name: "index_users_on_landlord_id"
  end

  add_foreign_key "apartments", "blocks"
  add_foreign_key "billings", "contracts"
  add_foreign_key "blocks", "buildings"
  add_foreign_key "buildings", "users", column: "landlord_id"
  add_foreign_key "charges", "billings"
  add_foreign_key "contracts", "apartments"
  add_foreign_key "contracts", "users", column: "landlord_id"
  add_foreign_key "contracts", "users", column: "tenant_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "users", "users", column: "landlord_id"
end
