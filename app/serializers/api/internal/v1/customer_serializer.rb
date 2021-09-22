class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :email, :name, :created_at

  attribute :current_billing_period_end_date, if: :active?
  attribute :previous_invoice_amount, if: :active?
  attribute :previous_invoice_currency, if: :active?
  attribute :current_period_details, if: :current_period_details?
  attribute :trial_finishes_at, if: :trial?

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

  def trial_finishes_at
    object.active_plan_subscription&.trial_finishes_at
  end

  def active?
    instance_options.present? && instance_options[:active]
  end

  def trial?
    instance_options.present? && instance_options[:trial]
  end

  def current_period_details?
    instance_options.present? && instance_options[:current_period_details]
  end

  private

  def previous_invoice
    @previous_invoice ||= object&.invoices&.last
  end
end
