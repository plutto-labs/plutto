PERMISSION_GROUP_PERMISSION_SCHEMA = {
  type: :object,
  properties: {
    limit: { type: :integer, example: 10, 'x-nullable': false },
    name: { type: :string, example: 'api-call', 'x-nullable': false }
  },
  required: [
    :limit,
    :name
  ]
}
