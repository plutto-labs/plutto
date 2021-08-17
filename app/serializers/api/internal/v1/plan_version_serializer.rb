class Api::Internal::V1::PlanVersionSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :version

  def version
    object.human_version
  end
end
