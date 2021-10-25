NOT_FOUND_ERROR_SCHEMA = {
  type: :object,
  properties: {
    type: { type: :string, example: 'invalid_request_error', 'x-nullable': false },
    code: { type: :string, example: 'resource_not_found', 'x-nullable': false },
    message: { type: :string, example: 'The requested resource cannot be found. This item does ' \
      'not exist or has been previously removed.', 'x-nullable': false },
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

NOT_FOUND_ERROR_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    error: { "$ref" => "#/components/schemas/not_found_error" }
  },
  required: [
    :error
  ]
}
