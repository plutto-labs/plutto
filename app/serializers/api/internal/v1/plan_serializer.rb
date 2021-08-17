class Api::Internal::V1::PlanSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :default_version
end
