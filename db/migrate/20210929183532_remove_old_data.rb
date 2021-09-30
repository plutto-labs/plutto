class RemoveOldData < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :pricings, :currency, :integer
      remove_column :pricings, :country_iso_code, :integer
      remove_column :pricings, :default_plan_version_id, :integer
      remove_column :pricings, :organization_id, :integer
      remove_column :pricings, :bills_at, :integer
      remove_column :pricings, :billing_period_duration, :integer

      remove_column :subscriptions, :plan_version_id, :pricing_id

      remove_column :price_logics, :plan_version_id

      remove_column :billing_periods, :plan_subscription_id

      drop_table :plan_versions
    end
  end
end
