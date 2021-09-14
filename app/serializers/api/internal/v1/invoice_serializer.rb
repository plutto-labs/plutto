class Api::Internal::V1::InvoiceSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :id, :subtotal, :tax_cents, :discount_cents, :currency,
             :issue_date, :details, :status, :customer_name, :customer_email

  def customer_name
    object.customer.name
  end

  def customer_email
    object.customer.email
  end

  def status
    object.status.camelize(:lower)
  end
end
