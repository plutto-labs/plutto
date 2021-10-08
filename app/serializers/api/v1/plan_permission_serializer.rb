class Api::V1::PlanPermissionSerializer < Api::BaseSerializer
  attributes  :limit, :name

  def name
    object.permission.name
  end
end
