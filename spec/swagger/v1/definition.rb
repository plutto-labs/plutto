API_V1 = {
  swagger: '2.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  host: 'sandbox.getplutto.com',
  definitions: {
    invoice: INVOICE_SCHEMA,
    invoice_resource: INVOICE_RESOURCE_SCHEMA,
    invoices_collection: INVOICES_COLLECTION_SCHEMA,
    subscription: SUBSCRIPTION_SCHEMA,
    subscription_create: SUBSCRIPTION_CREATE_SCHEMA,
    subscription_resource: SUBSCRIPTION_RESOURCE_SCHEMA,
    subscription_edit_pricings: SUBSCRIPTION_EDIT_PRICINGS_SCHEMA,
    customer: CUSTOMER_SCHEMA,
    customer_index: CUSTOMER_INDEX_SCHEMA,
    customer_resource: CUSTOMER_RESOURCE_SCHEMA,
    customer_create: CUSTOMER_CREATE_SCHEMA,
    customers_collection: CUSTOMERS_COLLECTION_SCHEMA,
    meter_event: METER_EVENT_SCHEMA,
    meter_event_create: METER_EVENT_CREATE_SCHEMA,
    meter_event_resource: METER_EVENT_RESOURCE_SCHEMA,
    pricing: PRICING_SCHEMA,
    pricing_resource: PRICING_RESOURCE_SCHEMA,
    price_logic: PRICE_LOGIC_SCHEMA,
    price_logic_resource: PRICE_LOGIC_RESOURCE_SCHEMA,
    unauthorized_error: UNAUTHORIZED_ERROR_SCHEMA,
    unauthorized_error_resource: UNAUTHORIZED_ERROR_RESOURCE_SCHEMA,
    not_found_error: NOT_FOUND_ERROR_SCHEMA,
    not_found_error_resource: NOT_FOUND_ERROR_RESOURCE_SCHEMA,
    unprocessable_entity_error: UNPROCESSABLE_ENTITY_ERROR_SCHEMA,
    unprocessable_entity_error_resource: UNPROCESSABLE_ENTITY_ERROR_RESOURCE_SCHEMA
  },
  securityDefinitions: {
    Bearer: {
      description: 'ApiKey token',
      type: :apiKey,
      name: 'Authorization',
      in: :header
    }
  }
}
