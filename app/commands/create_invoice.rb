class CreateInvoice < PowerTypes::Command.new(:billing_period, :customer)
  def perform
    invoice = Invoice.new(billing_period: @billing_period, customer: @customer)
    invoice.details = get_billing_amount_for_period
    invoice.subtotal = Money.new(invoice.details['price']['cents'], invoice.currency)
    # TODO: Add discount and tax logic
    invoice.discount_cents = 0
    invoice.tax_cents = 0
    invoice.issue_date = DateTime.current
    invoice.save!
    invoice
  end

  private

  def get_billing_amount_for_period
    BillingPeriodPriceDetails.for(billing_period: @billing_period)
  end
end
