class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :email, :name, :created_at, :updated_at
end
