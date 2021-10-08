PLAN_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'plan_d4328039347671a0b4b07f3f', 'x-nullable': false },
    name: { type: :string, example: 'Pro', 'x-nullable': false },
    plan_permissions: {
      type: :array,
      items: { "$ref" => "#/definitions/plan_permission" }
    }
  },
  required: [
    :id,
    :name
  ]
}

PLAN_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    plan: { "$ref" => "#/definitions/plan" }
  },
  required: [
    :plan
  ]
}
