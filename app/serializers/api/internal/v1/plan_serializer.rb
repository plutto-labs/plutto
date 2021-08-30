class Api::Internal::V1::PlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency, :bills_at, :plan_versions

  has_one :default_version
  has_many :plan_versions

  def plan_versions
    return unless instance_options.present? && instance_options[:include_versions]

    object.plan_versions.order(created_at: :desc)
  end
end
