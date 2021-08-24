class Api::BaseSerializer < ActiveModel::Serializer
  attributes :id

  def id
    object.identifier
  end
end
