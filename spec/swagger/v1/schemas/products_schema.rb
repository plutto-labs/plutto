PRODUCT_SCHEMA = {
  type: :object,
  properties: {
    id: {
      type: :string, example: 'product_d4328039347671a0b4b07f3f', 'x-nullable': false
    },
    name: { type: :string, example: 'Api calls', 'x-nullable': false },
    meter: { "$ref" => "#/components/schemas/meter" },
    pricings: {
      type: :array,
      items: { "$ref" => "#/components/schemas/pricing" }
    }
  },
  required: [
    :id,
    :name
  ]
}

PRODUCTS_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    products: {
      type: "array",
      items: { "$ref" => "#/components/schemas/product" }
    }
  },
  required: [
    :products
  ]
}
