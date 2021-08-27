class Api::V1::PlanSubscriptionSerializer < Api::BaseSerializer
  attributes  :id, :customer_id, :plan_version_id, :created_at, :updated_at, :active
end
