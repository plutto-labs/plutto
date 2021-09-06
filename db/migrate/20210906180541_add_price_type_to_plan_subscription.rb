class AddPriceTypeToPlanSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_subscriptions, :price_type, :integer, default: 0
  end
end
