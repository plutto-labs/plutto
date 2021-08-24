class ApiException::BaseException < StandardError
  include ActiveModel::Serialization
  attr_reader :type, :code, :http_code, :message, :detail, :param, :request_id, :docs_url

  def initialize(type:, code:, http_code:, message:, detail:, param:, request_id:, docs_url:)
    @type = type
    @code = code
    @http_code = http_code
    @message = message
    @detail = detail
    @param = param
    @request_id = request_id
    @docs_url = docs_url
  end

  def self.model_name
    'error'
  end
end
