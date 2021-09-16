API_V1 = {
  swagger: '2.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  definitions: {
    invoice: INVOICE_SCHEMA,
    invoice_resource: INVOICE_RESOURCE_SCHEMA,
    invoices_collection: INVOICES_COLLECTION_SCHEMA,
    plan_subscription: PLAN_SUBSCRIPTION_SCHEMA,
    plan_subscription_create: PLAN_SUBSCRIPTION_CREATE_SCHEMA,
    plan_subscription_resource: PLAN_SUBSCRIPTION_RESOURCE_SCHEMA,
    plan_subscriptions_collection: PLAN_SUBSCRIPTIONS_COLLECTION_SCHEMA,
    customer: CUSTOMER_SCHEMA,
    customer_create: CUSTOMER_CREATE_SCHEMA,
    customer_resource: CUSTOMER_RESOURCE_SCHEMA,
    customers_collection: CUSTOMERS_COLLECTION_SCHEMA,
    meter_event: METER_EVENT_SCHEMA,
    meter_event_create: METER_EVENT_CREATE_SCHEMA,
    meter_event_resource: METER_EVENT_RESOURCE_SCHEMA,
    unauthorized_error: UNAUTHORIZED_ERROR_SCHEMA,
    unauthorized_error_resource: UNAUTHORIZED_ERROR_RESOURCE_SCHEMA,
    not_found_error: NOT_FOUND_ERROR_SCHEMA,
    not_found_error_resource: NOT_FOUND_ERROR_RESOURCE_SCHEMA,
    argument_error: ARGUMENT_ERROR_SCHEMA,
    argument_error_resource: ARGUMENT_ERROR_RESOURCE_SCHEMA
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
