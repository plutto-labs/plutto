class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :email, :name, :created_at

  attribute :current_billing_period_end_date, if: :active?
  attribute :previous_invoice_amount, if: :active?
  attribute :previous_invoice_currency, if: :active?
  attribute :mercadopago_subscription_id, if: :active?
  attribute :current_period_details, if: :current_period_details?
  attribute :trial_finishes_at, if: :trial?
  attribute :meter_events_data, if: :show?

  has_one :active_subscription,
          serializer: Api::Internal::V1::SubscriptionSerializer, if: :show_or_active?
  has_one :billing_information, if: :show?
  has_many :payment_methods, if: :show?
  has_many :invoices, if: :show?

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
    object.active_subscription&.trial_finishes_at
  end

  def meter_events_data
    customer_analytics_service.meter_events_data
  end

  def mercadopago_subscription_id
    object.payment_methods.find_by(gateway: 'mercadopago')&.gateway_info&.dig('subscription_id')
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

  def show?
    instance_options.present? && instance_options[:show]
  end

  def show_or_active?
    show? || active?
  end

  def active_subscription
    object.active_subscription
  end

  private

  def previous_invoice
    @previous_invoice ||= object.invoices.where.not(status: 'canceled').last
  end

  def invoices
    @invoices ||= object&.invoices&.last(5)
  end

  def customer_analytics_service
    @customer_analytics_service ||= CustomerAnalyticsService.new(customer: object)
  end
end
