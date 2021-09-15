ARGUMENT_ERROR_SCHEMA = {
  type: :object,
  properties: {
    type: { type: :string, example: 'invalid_request_error', 'x-nullable': false },
    code: { type: :string, example: 'bad_request', 'x-nullable': false },
    message: { type: :string, example: 'The request was unacceptable, often due to missing a required parameter.', 'x-nullable': false },
    detail: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
    param: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
    request_id: { type: :string, example: '12d56103d1dfa382', 'x-nullable': true },
    docs_url: { type: :string, example: 'docs.getplutto.com', 'x-nullable': false }
  },
  required: [
    :type,
    :code,
    :message,
    :docs_url
  ]
}

ARGUMENT_ERROR_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    error: { "$ref" => "#/definitions/argument_error" }
  },
  required: [
    :error
  ]
}
