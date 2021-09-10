class RemoveAmountForBillingPeriod < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :billing_periods, :billing_amount_cents, :bigint
      remove_column :billing_periods, :billing_amount_currency, :string
    end
  end
end
