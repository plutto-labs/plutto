class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :identifier, :name, :email, :created_at, :updated_at

  has_one :billing_information
end
