class InvoiceService < PowerTypes::Service.new
  def send_to_customer(invoice)
    Analytics.track(
      user_id: invoice.customer.organization_id,
      event: 'send invoice',
      properties: invoice_properties(invoice)
    )
  end

  def charge(invoice, payment_method)
    kushki.charge(payment_method, invoice)
  end

  private

  def invoice_properties(invoice)
    {
      invoice_date: invoice.issue_date,
      invoice_total: { amount: invoice.subtotal.amount, currency: invoice.currency },
      details: invoice.details,
      customer_email: invoice.customer.email,
      customer_name: invoice.customer.name,
      customer_organization: invoice.customer.organization.name,
      billing_information: invoice.customer.billing_information&.serializable_hash,
      payment_link: kushki.enroll_link_for(invoice.customer)
    }
  end

  def kushki
    @kushki ||= KushkiService.new
  end
end
