CUSTOMER_PERMISSION_RESOURCE_SCHEMA = {
  type: :object,
  properties: {
    current_usage: { type: :integer, example: 10, 'x-nullable': true },
    limit: { type: :integer, example: 30, 'x-nullable': true },
    allowed: { type: :boolean, example: true, 'x-nullable': false },
    name: { type: :string, example: 'downloads', 'x-nullable': true }
  }
}

CUSTOMER_PERMISSIONS_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    customer_permissions: {
      type: "array",
      items: { "$ref" => "#/components/schemas/customer_permission_resource" }
    }
  },
  required: [
    :customer_permissions
  ]
}
