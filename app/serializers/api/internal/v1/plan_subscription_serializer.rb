class Api::Internal::V1::PlanSubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :plan_version_id, :plan_name,
             :plan_id, :created_at, :version, :trial_finishes_at

  def plan_name
    object.plan_version.plan.name
  end

  def plan_id
    object.plan_version.plan.id
  end

  def version
    "V#{object.plan_version.version}"
  end
end
