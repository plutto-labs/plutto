class Api::Internal::V1::SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :created_at, :trial_finishes_at, :currency,
             :bills_at, :billing_period_duration

  has_many :pricings, serializer: Api::Internal::V1::PricingSerializer
  has_one :permission_group

  def billing_period_duration
    object.billing_period_duration.iso8601
  end
end
