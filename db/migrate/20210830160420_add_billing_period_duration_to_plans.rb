class AddBillingPeriodDurationToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :billing_period_duration, :string
  end
end
