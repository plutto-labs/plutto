PRICE_LOGIC_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'price-logic_fkto44788dfglk82wz', 'x-nullable': false },
    type: { type: :string, example: 'FlatFee', 'x-nullable': false,
            enum: ['FaltFee', 'PerUnit', 'Volume', 'StairStep', 'Tiered'] },
    price: { type: :string, example: '1990.0', 'x-nullable': false },
    price_currency: { type: :string, example: 'USD', 'x-nullable': false },
    meter_count_method: {
      type: :string, example: 'period_sum', enum: ['period_sum', 'history_sum'],
      'x-nullable': true,
      description: 'If metered counts are from historic usage or just the current period usage'
    },
    price_logics: {
      type: :array, items: { "$ref" => "#/components/schemas/price_logic" }
    }
  },
  required: [
    :type,
    :price,
    :meter_count_method
  ]
}

PRICE_LOGIC_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    price_logic: { "$ref" => "#/components/schemas/price_logic" }
  },
  required: [
    :price_logic
  ]
}
