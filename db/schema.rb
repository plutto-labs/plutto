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

ActiveRecord::Schema.define(version: 2021_08_13_195902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "billing_counts", force: :cascade do |t|
    t.datetime "from", null: false
    t.datetime "to", null: false
    t.string "identifier"
    t.bigint "plan_subscription_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_billing_counts_on_identifier", unique: true
    t.index ["plan_subscription_id"], name: "index_billing_counts_on_plan_subscription_id"
  end

  create_table "billing_periods", force: :cascade do |t|
    t.datetime "from", null: false
    t.datetime "to", null: false
    t.string "identifier"
    t.bigint "plan_subscription_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_billing_periods_on_identifier", unique: true
    t.index ["plan_subscription_id"], name: "index_billing_periods_on_plan_subscription_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.jsonb "customer_info", default: {}
    t.string "identifier", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_customers_on_identifier", unique: true
    t.index ["organization_id"], name: "index_customers_on_organization_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "meter_counts", force: :cascade do |t|
    t.float "count", default: 0.0
    t.string "identifier"
    t.bigint "billing_period_id", null: false
    t.bigint "meter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["billing_period_id"], name: "index_meter_counts_on_billing_period_id"
    t.index ["identifier"], name: "index_meter_counts_on_identifier", unique: true
    t.index ["meter_id"], name: "index_meter_counts_on_meter_id"
  end

  create_table "meter_events", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.float "amount", default: 1.0
    t.integer "action", default: 0
    t.string "identifier"
    t.bigint "meter_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "meter_count_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_meter_events_on_action"
    t.index ["customer_id"], name: "index_meter_events_on_customer_id"
    t.index ["identifier"], name: "index_meter_events_on_identifier", unique: true
    t.index ["meter_count_id"], name: "index_meter_events_on_meter_count_id"
    t.index ["meter_id"], name: "index_meter_events_on_meter_id"
  end

  create_table "meters", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "meter_type", null: false
    t.index ["identifier"], name: "index_meters_on_identifier", unique: true
    t.index ["organization_id"], name: "index_meters_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plan_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "plan_version_id", null: false
    t.string "identifier", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_plan_subscriptions_on_customer_id"
    t.index ["identifier"], name: "index_plan_subscriptions_on_identifier", unique: true
    t.index ["plan_version_id"], name: "index_plan_subscriptions_on_plan_version_id"
  end

  create_table "plan_versions", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "previous_version_id"
    t.boolean "deployed", default: false
    t.string "identifier", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_plan_versions_on_identifier", unique: true
    t.index ["plan_id"], name: "index_plan_versions_on_plan_id"
    t.index ["previous_version_id"], name: "index_plan_versions_on_previous_version_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.string "identifier", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_plans_on_identifier", unique: true
    t.index ["organization_id"], name: "index_plans_on_organization_id"
  end

  create_table "price_logic_tiers", force: :cascade do |t|
    t.float "upper_limit", null: false
    t.float "lower_limit", null: false
    t.bigint "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "index", null: false
    t.string "tierable_type"
    t.bigint "tierable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tierable_type", "tierable_id"], name: "index_price_logic_tiers_on_tierable"
  end

  create_table "price_logics", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "billing_counts", "plan_subscriptions"
  add_foreign_key "billing_periods", "plan_subscriptions"
  add_foreign_key "customers", "organizations"
  add_foreign_key "meter_counts", "billing_periods"
  add_foreign_key "meter_counts", "meters"
  add_foreign_key "meter_events", "customers"
  add_foreign_key "meter_events", "meter_counts"
  add_foreign_key "meter_events", "meters"
  add_foreign_key "meters", "organizations"
  add_foreign_key "plan_subscriptions", "customers"
  add_foreign_key "plan_subscriptions", "plan_versions"
  add_foreign_key "plan_versions", "plan_versions", column: "previous_version_id"
  add_foreign_key "plan_versions", "plans"
  add_foreign_key "plans", "organizations"
  add_foreign_key "users", "organizations"
end
