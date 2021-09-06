class InvoiceObserver < PowerTypes::Observer
  after_create :track_invoice_created

  def track_invoice_created
    if should_send_invoice?
      Analytics.track(
        user_id: billing_period.plan_subscription.customer.organization_id,
        event: 'invoice created',
        properties: {
          invoice_date: object.issue_date,
          invoice_total: object.subtotal,
          details: object.details,
          customer_email: customer.email,
          customer_name: customer.name,
          organization_name: customer.organization.name
        }
      )
    end
  end

  private

  def should_send_invoice?
    plan_subscription.auto_collection?
  end

  def plan_subscription
    @plan_subscription ||= billing_period.plan_subscription
  end

  def billing_period
    @billing_period ||= object.billing_period
  end

  def customer
    @customer ||= object.customer
  end
end
