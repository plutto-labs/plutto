class Api::Internal::V1::SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :pricing_subscriptions, :created_at, :trial_finishes_at
end
