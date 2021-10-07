class AddPlanToSubscription < ActiveRecord::Migration[6.1]
  safety_assured do
    add_reference :subscriptions, :plan, foreign_key: true, index: true, type: :string
  end
end
