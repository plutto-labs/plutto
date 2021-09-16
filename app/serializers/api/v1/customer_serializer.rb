class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :identifier, :name, :email, :created_at, :updated_at

  attribute :active_plan_subscription_id, if: :deep_serialize?

  has_one :billing_information, if: :deep_serialize?

  def active_plan_subscription_id
    object.active_plan_subscription&.id
  end

  def billing_information
    object.billing_information
  end
end
