class Api::Internal::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :authentication_token

  has_one :organization

  def authentication_token
    return unless instance_options.present? && instance_options[:token]

    object.authentication_token
  end
end
