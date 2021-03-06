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

ActiveRecord::Schema.define(version: 2022_01_31_141619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :string, force: :cascade do |t|
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

  create_table "admin_users", id: :string, force: :cascade do |t|
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

  create_table "api_keys", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "bearer_id", null: false
    t.string "bearer_type", null: false
    t.string "token_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category", default: 0, null: false
    t.string "public_token"
    t.index ["bearer_id", "bearer_type"], name: "index_api_keys_on_bearer_id_and_bearer_type"
    t.index ["token_digest"], name: "index_api_keys_on_token_digest", unique: true
  end

  create_table "billing_informations", id: :string, force: :cascade do |t|
    t.string "legal_name"
    t.string "state"
    t.string "city"
    t.string "address"
    t.string "zip"
    t.string "activity"
    t.string "tax_id"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "customer_id", null: false
    t.integer "country_iso_code"
    t.index ["customer_id"], name: "index_billing_informations_on_customer_id"
  end

  create_table "billing_period_meter_data", id: :string, force: :cascade do |t|
    t.float "initial_count", default: 0.0
    t.float "final_count"
    t.string "billing_period_id", null: false
    t.string "meter_count_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["billing_period_id"], name: "index_billing_period_meter_data_on_billing_period_id"
    t.index ["meter_count_id", "billing_period_id"], name: "index_on_meter_count_id_and_billing_period_id", unique: true
    t.index ["meter_count_id"], name: "index_billing_period_meter_data_on_meter_count_id"
  end

  create_table "billing_periods", id: :string, force: :cascade do |t|
    t.datetime "from", null: false
    t.datetime "to", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "billing_date"
    t.string "subscription_id", null: false
    t.index ["subscription_id"], name: "index_billing_periods_on_subscription_id"
  end

  create_table "customers", id: :string, force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier"
    t.index ["organization_id", "identifier"], name: "index_customers_on_organization_id_and_identifier", unique: true
    t.index ["organization_id"], name: "index_customers_on_organization_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "invoices", id: :string, force: :cascade do |t|
    t.bigint "subtotal_cents", default: 0, null: false
    t.bigint "tax_cents", default: 0, null: false
    t.bigint "discount_cents", default: 0, null: false
    t.datetime "issue_date"
    t.jsonb "details", default: []
    t.string "billing_period_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "customer_id", null: false
    t.datetime "payed_at"
    t.integer "payment_method"
    t.integer "tax_type"
    t.string "document_id"
    t.jsonb "billing_information"
    t.bigint "total_cents"
    t.bigint "net_cents", default: 0, null: false
    t.integer "currency"
    t.integer "status", default: 0
    t.index ["billing_period_id"], name: "index_invoices_on_billing_period_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "meter_counts", id: :string, force: :cascade do |t|
    t.float "count", default: 0.0
    t.string "meter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "customer_id", null: false
    t.index ["customer_id", "meter_id"], name: "index_meter_counts_on_customer_id_and_meter_id", unique: true
    t.index ["customer_id"], name: "index_meter_counts_on_customer_id"
    t.index ["meter_id"], name: "index_meter_counts_on_meter_id"
  end

  create_table "meter_events", id: :string, force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.float "amount", default: 1.0
    t.integer "action", default: 0
    t.string "meter_id", null: false
    t.string "meter_count_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "idempotency_key"
    t.float "current_meter_count"
    t.string "billing_period_id"
    t.index ["action"], name: "index_meter_events_on_action"
    t.index ["billing_period_id"], name: "index_meter_events_on_billing_period_id"
    t.index ["meter_count_id"], name: "index_meter_events_on_meter_count_id"
    t.index ["meter_id"], name: "index_meter_events_on_meter_id"
  end

  create_table "meters", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_meters_on_organization_id"
  end

  create_table "organizations", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "settings"
    t.jsonb "widget_settings", default: {}
  end

  create_table "payment_methods", id: :string, force: :cascade do |t|
    t.string "customer_id", null: false
    t.integer "gateway", null: false
    t.integer "category", null: false
    t.jsonb "gateway_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "currency"
    t.string "last_4_digits"
    t.integer "card_brand"
    t.index ["customer_id"], name: "index_payment_methods_on_customer_id"
  end

  create_table "payments", id: :string, force: :cascade do |t|
    t.string "payment_method_id", null: false
    t.string "invoice_id", null: false
    t.string "id_in_gateway"
    t.integer "gateway"
    t.jsonb "payment_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
  end

  create_table "permission_group_permissions", id: :string, force: :cascade do |t|
    t.string "permission_group_id", null: false
    t.string "permission_id", null: false
    t.float "limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["permission_group_id"], name: "index_permission_group_permissions_on_permission_group_id"
    t.index ["permission_id"], name: "index_permission_group_permissions_on_permission_id"
  end

  create_table "permission_groups", id: :string, force: :cascade do |t|
    t.string "name"
    t.bigint "price_cents", default: 0, null: false
    t.integer "price_currency", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "organization_id", null: false
    t.boolean "zombie", default: false
    t.index ["organization_id"], name: "index_permission_groups_on_organization_id"
  end

  create_table "permissions", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "meter_id"
    t.integer "meter_count_method"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "organization_id", null: false
    t.index ["meter_id"], name: "index_permissions_on_meter_id"
    t.index ["name", "organization_id"], name: "index_permissions_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_permissions_on_organization_id"
  end

  create_table "price_logic_tiers", id: :string, force: :cascade do |t|
    t.float "upper_limit", null: false
    t.float "lower_limit", null: false
    t.bigint "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "index", null: false
    t.string "tierable_type"
    t.string "tierable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tierable_type", "tierable_id"], name: "index_price_logic_tiers_on_tierable"
  end

  create_table "price_logics", id: :string, force: :cascade do |t|
    t.string "type", null: false
    t.bigint "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "meter_count_method"
    t.string "pricing_id", null: false
    t.index ["pricing_id"], name: "index_price_logics_on_pricing_id"
  end

  create_table "pricing_subscriptions", id: :string, force: :cascade do |t|
    t.string "pricing_id", null: false
    t.string "subscription_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pricing_id"], name: "index_pricing_subscriptions_on_pricing_id"
    t.index ["subscription_id"], name: "index_pricing_subscriptions_on_subscription_id"
  end

  create_table "pricings", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "product_id"
    t.integer "currency"
    t.index ["product_id"], name: "index_pricings_on_product_id"
  end

  create_table "products", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "meter_id"
    t.string "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["meter_id"], name: "index_products_on_meter_id"
    t.index ["organization_id"], name: "index_products_on_organization_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.string "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "subscriptions", id: :string, force: :cascade do |t|
    t.string "customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.boolean "auto_collection", default: true
    t.integer "price_type", default: 0
    t.datetime "trial_finishes_at"
    t.integer "bills_at", default: 0, null: false
    t.string "billing_period_duration", null: false
    t.integer "currency", default: 0, null: false
    t.integer "country_iso_code", default: 0, null: false
    t.string "permission_group_id"
    t.boolean "zombie", default: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["permission_group_id"], name: "index_subscriptions_on_permission_group_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "organization_id"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.string "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "billing_informations", "customers"
  add_foreign_key "billing_period_meter_data", "billing_periods"
  add_foreign_key "billing_period_meter_data", "meter_counts"
  add_foreign_key "billing_periods", "subscriptions"
  add_foreign_key "customers", "organizations"
  add_foreign_key "invoices", "billing_periods"
  add_foreign_key "invoices", "customers"
  add_foreign_key "meter_counts", "customers"
  add_foreign_key "meter_counts", "meters"
  add_foreign_key "meter_events", "billing_periods"
  add_foreign_key "meter_events", "meter_counts"
  add_foreign_key "meter_events", "meters"
  add_foreign_key "meters", "organizations"
  add_foreign_key "payment_methods", "customers"
  add_foreign_key "payments", "invoices"
  add_foreign_key "payments", "payment_methods"
  add_foreign_key "permission_group_permissions", "permission_groups"
  add_foreign_key "permission_group_permissions", "permissions"
  add_foreign_key "permission_groups", "organizations"
  add_foreign_key "permissions", "meters"
  add_foreign_key "permissions", "organizations"
  add_foreign_key "price_logics", "pricings"
  add_foreign_key "pricing_subscriptions", "pricings"
  add_foreign_key "pricing_subscriptions", "subscriptions"
  add_foreign_key "pricings", "products"
  add_foreign_key "products", "meters"
  add_foreign_key "products", "organizations"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "permission_groups"
  add_foreign_key "users", "organizations"
end
