UNAUTHORIZED_ERROR_SCHEMA = {
  type: :object,
  properties: {
    type: { type: :string, example: 'authentication_error', 'x-nullable': false },
    code: { type: :string, example: 'unauthorized', 'x-nullable': false },
    message: { type: :string, example: 'No valid API key provided.', 'x-nullable': false },
    detail: { type: :string, example: '', 'x-nullable': true },
    param: { type: :string, example: '', 'x-nullable': true },
    request_id: { type: :string, example: '', 'x-nullable': true },
    docs_url: { type: :string, example: 'docs.getplutto.com/docs/authorization',
                'x-nullable': false }
  },
  required: [
    :type,
    :code,
    :message,
    :docs_url
  ]
}

UNAUTHORIZED_ERROR_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    error: { "$ref" => "#/components/schemas/unauthorized_error" }
  },
  required: [
    :error
  ]
}
