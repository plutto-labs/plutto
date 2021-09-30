class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :identifier, :name, :email, :created_at, :updated_at

  has_one :active_subscription, if: :deep_serialize?
  has_one :billing_information, if: :deep_serialize?

  def billing_information
    object.billing_information
  end
end
