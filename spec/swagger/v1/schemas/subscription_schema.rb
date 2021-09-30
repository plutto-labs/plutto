SUBSCRIPTION_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'subscription_80b199c7744342f3c5df8622', 'x-nullable': false },
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    pricing_ids: {
      type: :array,
      example: '[price_d43280e9377673a0b4b07f31, price_d43280e9377673a123407f31]',
      'x-nullable': true
    },
    created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': false },
    updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
    active: { type: :boolean, example: true, 'x-nullable': false },
    trial_finishes_at: { type: :string, example: '1984-06-04 09:00',
                         'x-nullable': true, format: 'date' }
  },
  required: [
    :id,
    :customer_id,
    :pricing_ids,
    :created_at,
    :active
  ]
}

SUBSCRIPTION_CREATE_SCHEMA = {
  type: :object,
  properties: {
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    pricing_ids: { type: :string, example: 'price_46cf463812d56103d1dfa382',
                         'x-nullable': true },
    trial_finishes_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true,
                         format: 'date' }
  },
  required: [
    :customer_id
  ]
}

SUBSCRIPTION_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    subscription: { "$ref" => "#/definitions/subscription" }
  },
  required: [
    :subscription
  ]
}
