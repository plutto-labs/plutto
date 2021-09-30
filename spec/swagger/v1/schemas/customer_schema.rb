CUSTOMER_INDEX_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'customer_d43280e9377673a0b4b07f31', 'x-nullable': false },
    email: { type: :string, example: 'donald@getplutto.com', 'x-nullable': false },
    name: { type: :string, example: 'donald', 'x-nullable': true },
    created_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true,
                  format: 'date-time' },
    updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true,
                  format: 'date-time' },
    identifier: { type: :string, example: 'your-id_12885305', 'x-nullable': true },
  },
  required: [:id, :email]
}

CUSTOMER_SCHEMA = {
  type: :object,
  properties: {
    identifier: { type: :string, example: 'your-id_12885305', 'x-nullable': true },
    email: { type: :string, example: 'donald@getplutto.com', 'x-nullable': false },
    name: { type: :string, example: 'donald', 'x-nullable': true },
    subscription: {
      type: :object,
      properties: {
        customer: { "$ref" => "#/definitions/subscription" }
      },
      'x-nullable': true
    },
    billing_information: {
      type: :object, 'x-nullable': true, properties: {
        city: { type: :string, example: 'Santiago', 'x-nullable': true },
        country_iso_code: { type: :string, example: 'CHL', 'x-nullable': false },
        state: { type: :string, example: 'Metropolitana', 'x-nullable': true },
        billing_address: { type: :string, example: 'Av. Las Condes', 'x-nullable': true },
        zip: { type: :string, example: '12345', 'x-nullable': true },
        tax_id: { type: :string, example: '73245432-1', 'x-nullable': true },
        legal_name: { type: :string, example: 'Plutto Inc', 'x-nullable': true },
        activity: { type: :string, example: 'Software Development', 'x-nullable': true },
        phone: { type: :string, example: '+56992680522', 'x-nullable': true }
      }
    }
  },
  required: [:email, :billing_information]
}

CUSTOMERS_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    customers: {
      type: "array",
      items: { "$ref" => "#/definitions/customer_index" }
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
