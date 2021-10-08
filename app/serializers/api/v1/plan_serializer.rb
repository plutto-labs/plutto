class Api::V1::PlanSerializer < Api::BaseSerializer
  attributes  :id, :name

  has_many :plan_permissions, serializer: Api::V1::PlanPermissionSerializer
end
