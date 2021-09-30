class Api::V1::SubscriptionSerializer < Api::BaseSerializer
  attributes  :id, :customer_id, :created_at, :updated_at, :active, :trial_finishes_at, :bills_at,
              :pricing_ids, :billing_period_duration

  def pricing_ids
    object.pricings.pluck(:id)
  end

  def billing_period_duration
    object.billing_period_duration.iso8601
  end
end
