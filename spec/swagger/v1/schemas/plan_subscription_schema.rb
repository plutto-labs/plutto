PLAN_SUBSCRIPTION_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'subscription_80b199c7744342f3c5df8622', 'x-nullable': false },
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    plan_version_id: { type: :string, example: 'version_46cf463812d56103d1dfa382',
                       'x-nullable': false },
    created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': false },
    updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
    active: { type: :boolean, example: true, 'x-nullable': false }
  },
  required: [
    :id,
    :customer_id,
    :plan_version_id,
    :created_at,
    :active
  ]
}

PLAN_SUBSCRIPTION_CREATE_SCHEMA = {
  type: :object,
  properties: {
    customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                   'x-nullable': false },
    plan_version_id: { type: :string, example: 'version_46cf463812d56103d1dfa382',
                       'x-nullable': true },
    plan_id: { type: :string, example: 'plan_5b3bebe4704f9588cfa10413', 'x-nullable': true }
  },
  required: [
    :customer_id
  ]
}

PLAN_SUBSCRIPTION_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    plan_subscription: { "$ref" => "#/definitions/plan_subscription" }
  },
  required: [
    :plan_subscription
  ]
}
