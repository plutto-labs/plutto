class AddBillingDateToBillingPeriod < ActiveRecord::Migration[6.1]
  def change
    add_column :billing_periods, :billing_date, :datetime
    add_monetize :billing_periods, :billing_amount
  end
end
