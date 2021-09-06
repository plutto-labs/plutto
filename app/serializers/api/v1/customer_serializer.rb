class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :identifier, :email, :name, :created_at, :updated_at
end
