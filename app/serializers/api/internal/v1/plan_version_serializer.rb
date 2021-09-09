class Api::Internal::V1::PlanVersionSerializer < ActiveModel::Serializer
  attributes :id, :version, :subscribed_users

  has_many :price_logics

  def version
    "V#{object.version}"
  end

  def subscribed_users
    object.plan_subscriptions.where(active: true).count
  end
end
