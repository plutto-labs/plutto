CUSTOMER_PERMISSION_RESOURCE_SCHEMA = {
  type: :object,
  properties: {
    current_usage: { type: :integer, example: 10, 'x-nullable': true },
    limit: { type: :integer, example: 30, 'x-nullable': true },
    allowed: { type: :boolean, example: true, 'x-nullable': false },
    name: { type: :string, example: 'downloads', 'x-nullable': true }
  }
}
