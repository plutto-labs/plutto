class AddAutoCollectionToPlanSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_subscriptions, :auto_collection, :boolean, default: true
  end
end
