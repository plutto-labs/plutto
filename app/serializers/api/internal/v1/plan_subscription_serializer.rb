class Api::Internal::V1::PlanSubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :plan_version_id, :plan_name, :created_at

  def plan_name
    object.plan_version.plan.name
  end
end