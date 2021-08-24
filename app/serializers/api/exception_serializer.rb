class Api::ExceptionSerializer < ActiveModel::Serializer
  attributes :type, :code, :message, :detail, :param, :request_id, :docs_url
end
