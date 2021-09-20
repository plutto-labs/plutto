class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :email, :name

  attribute :current_billing_period_end_date, if: :active?
  attribute :previous_invoice_amount, if: :active?
  attribute :previous_invoice_currency, if: :active?

  has_one :active_plan_subscription, serializer: Api::Internal::V1::PlanSubscriptionSerializer
  has_one :billing_information

  def previous_invoice_amount
    previous_invoice&.subtotal&.amount
  end

  def previous_invoice_currency
    previous_invoice&.currency
  end

  def current_billing_period_end_date
    object.current_billing_period&.to
  end

  def active?
    instance_options.present? && instance_options[:active]
  end

  private

  def previous_invoice
    @previous_invoice ||= object.previous_billing_period&.invoice
  end
end
