SUBSCRIPTION_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'subscription_80b199c7744342f3c5df8622', 'x-nullable': false },
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    pricings: {
      type: :array,
      items: { "$ref" => "#/definitions/pricing" }
    },
    created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': false },
    updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
    active: { type: :boolean, example: true, 'x-nullable': false },
    trial_finishes_at: { type: :string, example: '1984-06-04 09:00',
                         'x-nullable': true, format: 'date' },
    bills_at: { type: :string, example: 'end', 'x-nullable': false, enum: ['start', 'end'],
                description: 'choose wether the subscription should be billed at the start ' \
                'or end of the period. Note that usage based subscriptions are can only be ' \
                'billed at the end of the period.' },
    billing_period_duration: {
      type: :string, example: 'P0Y1M0DT0H0M0S', 'x-nullable': false,
      description: 'ISO 8601 duration for a billing period'
    }
  },
  required: [
    :id,
    :customer_id,
    :pricings,
    :created_at,
    :active,
    :bills_at,
    :billing_period_duration
  ]
}

SUBSCRIPTION_CREATE_SCHEMA = {
  type: :object,
  properties: {
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    pricing_ids: {
      type: :array,
      items: { type: :string, example: 'pricing_5198c6ad60c3363b089a1422' },
      'x-nullable': false
    },
    trial_finishes_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true,
                         format: 'date' },
    bills_at: { type: :string, example: 'end', 'x-nullable': false, enum: ['start', 'end'],
                description: 'choose wether the subscription should be billed at the start or ' \
                'end of the period. Note that usage based subscriptions are can only be billed ' \
                'at the end of the period.' },
    billing_period_duration: {
      type: :string, example: 'P0Y1M0DT0H0M0S', 'x-nullable': false,
      description: 'ISO 8601 duration for a billing period'
    }
  },
  required: [
    :customer_id, :pricing_ids, :billing_period_duration, :bills_at
  ]
}

SUBSCRIPTION_EDIT_PRICINGS_SCHEMA = {
  type: :object,
  properties: {
    pricings_ids: {
      type: :array,
      items: { type: :string, example: 'pricing_5198c6ad60c3363b089a1422', 'x-nullable': false }
    }
  },
  required: [:pricings_ids]
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
