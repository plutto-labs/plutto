class Api::Internal::V1::SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :pricing_subscriptions, :created_at, :trial_finishes_at, :bills_at,
             :pricing_ids, :billing_period_duration

  def pricing_ids
    object.pricings.pluck(:id)
  end

  def billing_period_duration
    object.billing_period_duration.iso8601
  end
end
