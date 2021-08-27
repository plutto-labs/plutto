API_V1 = {
  swagger: '2.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  definitions: {
    plan_subscription: PLAN_SUBSCRIPTION_SCHEMA,
    plan_subscription_create: PLAN_SUBSCRIPTION_CREATE_SCHEMA,
    plan_subscription_resource: PLAN_SUBSCRIPTION_RESOURCE_SCHEMA,
    plan_subscriptions_collection: PLAN_SUBSCRIPTIONS_COLLECTION_SCHEMA,
    customer: CUSTOMER_SCHEMA,
    customer_create: CUSTOMER_CREATE_SCHEMA,
    customer_resource: CUSTOMER_RESOURCE_SCHEMA,
    customers_collection: CUSTOMERS_COLLECTION_SCHEMA,
    unauthorized_error: UNAUTHORIZED_ERROR_SCHEMA,
    unauthorized_error_resource: UNAUTHORIZED_ERROR_RESOURCE_SCHEMA
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
