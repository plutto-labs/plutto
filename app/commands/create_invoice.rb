class CreateInvoice < PowerTypes::Command.new(:billing_period, :customer)
  def perform
    invoice = Invoice.new(billing_period: @billing_period, customer: @customer)
    billing_period_details = get_billing_amount_for_period
    invoice.details = billing_period_details['details']
    invoice.subtotal = Money.new(billing_period_details['price'], invoice.currency)
    # TODO: Add discount
    invoice.discount_cents = 0
    invoice.issue_date = DateTime.current
    invoice.billing_information = @customer.billing_information.as_json
    invoice.save!
    invoice
  end

  private

  def get_billing_amount_for_period
    BillingPeriodPriceDetails.for(billing_period: @billing_period)
  end
end
