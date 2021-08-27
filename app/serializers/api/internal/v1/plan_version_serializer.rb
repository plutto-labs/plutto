class Api::Internal::V1::PlanVersionSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :version

  has_many :price_logics

  def version
    "V#{object.version}"
  end
end
