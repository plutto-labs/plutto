INVOICE_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: '1', 'x-nullable': false },
    subtotal_cents: { type: :integer, example: 10000, 'x-nullable': false },
    tax_cents: { type: :integer, example: 190, 'x-nullable': true },
    discount_cents: { type: :integer, example: 0, 'x-nullable': true },
    currency: { type: :string, example: 'USD', 'x-nullable': false },
    issue_date: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true },
    details: {
      type: :array,
      items: {
        properties: {
          type: { type: :string, 'x-nullable': true },
          total_price_cents: { type: :integer, 'x-nullable': true },
          meter: { type: :string, 'x-nullable': true },
          quantity: { type: :integer, 'x-nullable': true }
        }
      },
      example: "[{ type: 'flat_fee', total_price_cents: 100 },
      { type: 'volume', total_price_cents: 25000, meter: 'Requests', quantity: 250.0 }]",
      'x-nullable': false
    },
    created_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true },
    updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true },
    customer_id: { type: :string, example: 'customer_d43280e9377673a0b4b07f31',
                   'x-nullable': false },
    status: { type: :string, example: 'paid', 'x-nullable': false },
    payed_at: { type: :string, example: '2020-01-01T00:00:00.000Z', 'x-nullable': true },
    payment_method: { type: :string, example: 'bank_transfer', 'x-nullable': true },
    tax_type: { type: :string, example: 'VAT', 'x-nullable': true },
    document_id: { type: :string, example: 'some-id', 'x-nullable': true },
    billing_information: { type: :object, example: "{'customer': customer,
      'city': 'Santiago',
      'country_iso_code': 'CHL',
      'state': 'Metropolitana',
      'address': 'Av. Las Condes',
      'zip': '12345',
      'tax_id': '73245432-1',
      'phone': '9550898',
      'legal_name': 'Plutto Inc'}",
                           'x-nullable': true }
  },
  required: [
    :id,
    :subtotal_cents,
    :tax_cents,
    :discount_cents,
    :currency,
    :issue_date,
    :details,
    :created_at,
    :customer_id,
    :status,
    :payment_method,
    :tax_type,
    :billing_information
  ]
}

INVOICES_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    invoices: {
      type: "array",
      items: { "$ref" => "#/definitions/invoice" }
    }
  },
  required: [
    :invoices
  ]
}

INVOICE_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    invoice: { "$ref" => "#/definitions/invoice" }
  },
  required: [
    :invoice
  ]
}
