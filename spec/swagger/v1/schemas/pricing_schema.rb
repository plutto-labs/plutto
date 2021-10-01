PRICING_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'pricing_d4328039347671a0b4b07f3f', 'x-nullable': false },
    name: { type: :string, example: 'Basic', 'x-nullable': false },
    currency: { type: :string, example: 'USD', 'x-nullable': false },
    product_id: { type: :string, example: 'product_ff3s803su47n71a0b4b07f3f', 'x-nullable': false },
    price_logics: {
      type: :array, items: { "$ref" => "#/definitions/price_logic" }
    }
  },
  required: [
    :id,
    :name,
    :currency,
    :product_id
  ]
}

PRICING_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    pricing: { "$ref" => "#/definitions/pricing" }
  },
  required: [
    :pricing
  ]
}
