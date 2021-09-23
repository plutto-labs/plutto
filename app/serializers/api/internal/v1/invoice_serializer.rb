class Api::Internal::V1::InvoiceSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :id, :subtotal, :tax, :discount, :currency,
             :issue_date, :details, :status, :customer_name, :customer_email
  attribute :billing_information, if: :show?
  attribute :permitted_events, if: :show?

  def customer_name
    object.customer.name
  end

  def customer_email
    object.customer.email
  end

  def status
    object.status.camelize(:lower)
  end

  def billing_information
    object.billing_information
  end

  def permitted_events
    object.aasm.permitted_transitions.map(
      &(Proc.new { |hash| hash.transform_values { |value| value.to_s.camelize(:lower) } })
    )
  end

  def show?
    instance_options.present? && instance_options[:show]
  end
end
