class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :email, :name

  has_one :active_plan_subscription, serializer: Api::Internal::V1::PlanSubscriptionSerializer
end
