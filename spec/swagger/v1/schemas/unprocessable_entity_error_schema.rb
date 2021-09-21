UNPROCESSABLE_ENTITY_ERROR_SCHEMA = {
  type: :object,
  properties: {
    type: { type: :string, example: 'invalid_request_error', 'x-nullable': false },
    code: { type: :string, example: 'unprocessable', 'x-nullable': false },
    message: { type: :string, example: 'Your request was understood, but we were not able to ' \
      'process it. Please fix it before repeating', 'x-nullable': false },
    detail: { type: :string, example: '', 'x-nullable': true },
    param: { type: :string, example: '', 'x-nullable': true },
    request_id: { type: :string, example: '', 'x-nullable': true },
    docs_url: { type: :string, example: 'docs.getplutto.com', 'x-nullable': false }
  },
  required: [
    :type,
    :code,
    :message,
    :docs_url
  ]
}

UNPROCESSABLE_ENTITY_ERROR_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    error: { "$ref" => "#/definitions/unprocessable_entity_error" }
  },
  required: [
    :error
  ]
}
