class Api::Internal::V1::PlanVersionSerializer < ActiveModel::Serializer
  attributes :identifier, :version

  def version
    object.human_version
  end
end
