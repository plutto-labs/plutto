class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :authentication_token

  def authentication_token
    return unless instance_options.present? && instance_options[:token]

    object.authentication_token
  end
end
