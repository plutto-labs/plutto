METER_EVENT_SCHEMA = {
  type: :object,
  properties: {
    timestamp: { type: :string, example: '2021-06-04 09:00' },
    amount: { type: :number, example: 1000, 'x-nullable': false },
    action: { type: :string, example: 'set', 'x-nullable': false },
    id: { type: :string, example: 'event_80b199c7744342f3c5df8622', 'x-nullable': false },
    meter_id: { type: :string, example: 10, 'x-nullable': false },
    created_at: { type: :string, example: '2021-06-04 09:00', 'x-nullable': false },
    idempotency_key: { type: :string, example: 'Some idempotency_key', 'x-nullable': true },
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false }
  },
  required: [
    :timestamp,
    :action,
    :amount,
    :meter_id,
    :customer_id,
    :created_at
  ]
}

METER_EVENT_CREATE_SCHEMA = {
  type: :object,
  properties: {
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    meter_id: { type: :string, example: 'meter_46cf463812d56103d1dfa382',
                'x-nullable': false },
    amount: { type: :number, example: 6.66, 'x-nullable': false },
    action: { type: :string, example: 'increment', 'x-nullable': false },
    timestamp: { type: :string, example: '2021-06-04 09:00' }
  },
  required: [
    :action,
    :amount,
    :customer_id,
    :meter_id
  ]
}

METER_EVENT_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    meter_event: { "$ref" => "#/definitions/meter_event" }
  },
  required: [
    :meter_event
  ]
}
