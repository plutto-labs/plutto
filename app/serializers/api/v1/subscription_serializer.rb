class Api::V1::SubscriptionSerializer < Api::BaseSerializer
  attributes  :id, :customer_id, :created_at, :updated_at, :active, :trial_finishes_at, :bills_at,
              :billing_period_duration

  has_many :pricings, serializer: Api::V1::PricingSerializer
  has_one :permission_group, serializer: Api::V1::PermissionGroupSerializer

  def billing_period_duration
    object.billing_period_duration.iso8601
  end

  def pricings
    object.pricings.includes([:price_logics])
  end
end
