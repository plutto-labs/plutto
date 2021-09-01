class CreateInvoice < PowerTypes::Command.new(:billing_period)
  def perform
    invoice = Invoice.new(billing_period: @billing_period)
    invoice.subtotal = get_billing_amount_for_period(invoice)
    # TODO: Add discount and tax logic
    invoice.discount_cents = 0
    invoice.tax_cents = 0
    invoice.issue_date = DateTime.current
    invoice.save!
    invoice
  end

  private

  def get_billing_amount_for_period(invoice)
    BillingPeriodPriceDetails.for(billing_period: @billing_period, invoice: invoice)
  end
end
