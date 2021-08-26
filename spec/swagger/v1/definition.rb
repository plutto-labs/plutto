API_V1 = {
  swagger: '3.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  definitions: {
    plan_subscription: PLAN_SUBSCRIPTION_SCHEMA,
    plan_subscriptions_collection: PLAN_SUBSCRIPTIONS_COLLECTION_SCHEMA,
    plan_subscription_resource: PLAN_SUBSCRIPTION_RESOURCE_SCHEMA,
    customer: CUSTOMER_SCHEMA,
    customers_collection: CUSTOMERS_COLLECTION_SCHEMA,
    customer_resource: CUSTOMER_RESOURCE_SCHEMA
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
