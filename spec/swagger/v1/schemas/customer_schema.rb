CUSTOMER_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'customer_d43280e9377673a0b4b07f31', 'x-nullable': false },
    name: { type: :string, example: 'Plutto Donald', 'x-nullable': true },
    email: { type: :string, example: 'donald@getplutto.com', 'x-nullable': false,
             format: 'email' },
    created_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true,
                  format: 'date-time' },
    updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true,
                  format: 'date-time' }
  },
  required: [
    :id,
    :email
  ]
}

CUSTOMERS_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    customers: {
      type: "array",
      items: { "$ref" => "#/definitions/customer" }
    }
  },
  required: [
    :customers
  ]
}

CUSTOMER_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    customer: { "$ref" => "#/definitions/customer" }
  },
  required: [
    :customer
  ]
}
