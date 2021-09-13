class Api::V1::InvoiceSerializer < Api::BaseSerializer
  attributes :id, :subtotal_cents, :tax_cents, :discount_cents, :currency, :issue_date,
             :created_at, :updated_at, :customer_id, :status, :payed_at,
             :payment_method, :tax_type, :document_id, :customer_name,
             :customer_email, :details, :billing_information

  def billing_information
    billing_information_model = BillingInformation.new(object.billing_information)

    options = { serializer: Api::V1::BillingInformationSerializer }

    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      billing_information_model, options
    )
    serializable_resource.as_json[:billing_information]
  end

  def customer_name
    object.customer.name
  end

  def customer_email
    object.customer.email
  end
end
