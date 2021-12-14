API_V1 = {
  openapi: '3.0.1',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  servers: [
    {
      url: 'https://sandbox.getplutto.com/api/v1',
      description: 'Sandbox server (uses test data)'
    }, {
      url: 'https://app.getplutto.com/api/v1',
      description: 'Production server (uses live data)'
    }
  ],
  components: {
    schemas: {
      invoice: INVOICE_SCHEMA,
      invoice_resource: INVOICE_RESOURCE_SCHEMA,
      invoices_collection: INVOICES_COLLECTION_SCHEMA,
      invoice_mark_as: INVOICE_MARK_AS_SCHEMA,
      subscription: SUBSCRIPTION_SCHEMA,
      subscription_create: SUBSCRIPTION_CREATE_SCHEMA,
      subscription_resource: SUBSCRIPTION_RESOURCE_SCHEMA,
      subscription_edit_pricings: SUBSCRIPTION_EDIT_PRICINGS_SCHEMA,
      customer: CUSTOMER_SCHEMA,
      customer_index: CUSTOMER_INDEX_SCHEMA,
      customer_resource: CUSTOMER_RESOURCE_SCHEMA,
      customer_permission_resource: CUSTOMER_PERMISSION_RESOURCE_SCHEMA,
      customer_permissions_collection: CUSTOMER_PERMISSIONS_COLLECTION_SCHEMA,
      customer_create: CUSTOMER_CREATE_SCHEMA,
      customer_update: CUSTOMER_UPDATE_SCHEMA,
      customers_collection: CUSTOMERS_COLLECTION_SCHEMA,
      meter: METER_SCHEMA,
      meter_event: METER_EVENT_SCHEMA,
      meter_event_create: METER_EVENT_CREATE_SCHEMA,
      meter_event_resource: METER_EVENT_RESOURCE_SCHEMA,
      permission_group: PERMISSION_GROUP_SCHEMA,
      permission_group_permission: PERMISSION_GROUP_PERMISSION_SCHEMA,
      permission_groups_collection: PERMISSION_GROUPS_COLLECTION_SCHEMA,
      pricing: PRICING_SCHEMA,
      pricing_resource: PRICING_RESOURCE_SCHEMA,
      price_logic: PRICE_LOGIC_SCHEMA,
      price_logic_resource: PRICE_LOGIC_RESOURCE_SCHEMA,
      product: PRODUCT_SCHEMA,
      products_collection: PRODUCTS_COLLECTION_SCHEMA,
      unauthorized_error: UNAUTHORIZED_ERROR_SCHEMA,
      unauthorized_error_resource: UNAUTHORIZED_ERROR_RESOURCE_SCHEMA,
      not_found_error: NOT_FOUND_ERROR_SCHEMA,
      not_found_error_resource: NOT_FOUND_ERROR_RESOURCE_SCHEMA,
      unprocessable_entity_error: UNPROCESSABLE_ENTITY_ERROR_SCHEMA,
      unprocessable_entity_error_resource: UNPROCESSABLE_ENTITY_ERROR_RESOURCE_SCHEMA
    },
    securitySchemes: {
      Bearer: {
        type: :http,
        scheme: :bearer
      }
    }
  }
}
