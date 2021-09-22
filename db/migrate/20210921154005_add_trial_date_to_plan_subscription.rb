class AddTrialDateToPlanSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_subscriptions, :trial_finishes_at, :datetime, default: nil
  end
end
