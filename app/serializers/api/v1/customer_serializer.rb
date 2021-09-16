class Api::V1::CustomerSerializer < Api::BaseSerializer
  attributes :id, :identifier, :name, :email, :created_at, :updated_at,
             :active_plan_subscription_id

  has_one :billing_information

  def active_plan_subscription_id
    return unless instance_options.present? && instance_options[:include_active_subscription]

    object.active_plan_subscription&.id
  end
end
