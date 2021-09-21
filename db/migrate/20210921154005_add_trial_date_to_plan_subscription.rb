class AddTrialDateToPlanSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_subscriptions, :trial_date, :datetime, default: nil
  end
end
