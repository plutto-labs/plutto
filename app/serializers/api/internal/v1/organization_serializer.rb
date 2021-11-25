class Api::Internal::V1::OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :settings, :widget_settings, :public_api_key

  def public_api_key
    object.public_api_key.token
  end
end
