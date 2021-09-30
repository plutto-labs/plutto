class InvoiceObserver < PowerTypes::Observer
  after_create :track_invoice_created

  def track_invoice_created
    if should_send_invoice?
      Analytics.track(
        user_id: billing_period.subscription.customer.organization_id,
        event: 'invoice created',
        properties: {
          invoice_date: object.issue_date,
          invoice_total: object.subtotal,
          details: object.details,
          customer_email: customer.email,
          customer_name: customer.name,
          organization_name: customer.organization.name,
          billing_information: customer.billing_information&.serializable_hash
        }
      )
    end
  end

  private

  def should_send_invoice?
    subscription.auto_collection?
  end

  def subscription
    @subscription ||= billing_period.subscription
  end

  def billing_period
    @billing_period ||= object.billing_period
  end

  def customer
    @customer ||= object.customer
  end
end
