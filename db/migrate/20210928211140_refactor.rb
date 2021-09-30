class Refactor < ActiveRecord::Migration[6.1]
  class PlanVersion < ActiveRecord::Base
  end

  class Plan < ActiveRecord::Base
  end

  class PlanSubscription < ActiveRecord::Base
  end

  def change
    safety_assured do # do not fear :joy:
      # Clean database
      remove_foreign_key :plan_versions, column: :previous_version_id
      remove_foreign_key :plans, column: :default_plan_version_id

      Invoice.delete_all
      MeterEvent.delete_all
      BillingPeriodMeterData.delete_all
      BillingPeriod.delete_all
      PlanSubscription.delete_all
      PriceLogic::Tier.delete_all
      PriceLogic.delete_all
      PlanVersion.delete_all
      Plan.delete_all

      # Create new products table
      create_table :products, id: :string do |t|
        t.string :name
        t.references :meter, foreign_key: true, index: true, type: :string
        t.references :organization, foreign_key: true, index: true, type: :string

        t.timestamps
      end

      # Refactor old tables
      remove_index :plans, name: :index_plans_on_default_plan_version_id
      remove_index :plans, name: :index_plans_on_organization_id
      remove_index :plan_subscriptions, name: 'index_plan_subscriptions_on_plan_version_id'
      remove_index :price_logic, name: 'index_price_logics_on_plan_version_id'
      remove_index :billing_periods, name: 'index_billing_periods_on_plan_subscription_id'

      rename_table :plans, :pricings
      rename_table :plan_subscriptions, :subscriptions

      # Create table for n-m relations
      create_table :pricing_subscriptions, id: :string do |t|
        t.references :pricing, null: false, foreign_key: true, index: true, type: :string
        t.references :subscription, null: false, foreign_key: true, index: true, type: :string

        t.timestamps
      end

      # Add product to product prices and remove old indexes
      add_reference :pricings, :product, foreign_key: true, index: true, type: :string

      # Add new fields to subscriptions. Before they were in plans
      add_column :subscriptions, :bills_at, :integer, default: 0
      add_column :subscriptions, :billing_period_duration, :string
      add_column :subscriptions, :currency, :integer, default: 0, null: false
      add_column :subscriptions, :country_iso_code, :integer, default: 0, null: false

      # Add relation from price_logics to pricings
      add_reference :price_logics, :pricing, index: true, foreign_key: true, null: false, type: :string

      # Add relation from billing_periods to subscription instead of plans
      add_reference :billing_periods, :subscription, index: true, foreign_key: true, null: false, type: :string
    end
  end
end
