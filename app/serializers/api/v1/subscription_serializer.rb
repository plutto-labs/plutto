class Api::V1::SubscriptionSerializer < Api::BaseSerializer
  attributes  :id, :customer_id, :created_at, :updated_at, :active, :trial_finishes_at, :bills_at,
              :billing_period_duration

  def billing_period_duration
    object.billing_period_duration.iso8601
  end
end
