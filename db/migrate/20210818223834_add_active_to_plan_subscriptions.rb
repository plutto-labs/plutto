class AddActiveToPlanSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_subscriptions, :active, :boolean, default: false
  end
end
