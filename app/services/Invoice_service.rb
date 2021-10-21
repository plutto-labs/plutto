class InvoiceService < PowerTypes::Service.new(:invoice)
  def post!(include_payment_link = false)
    Analytics.track(
      user_id: @invoice.customer.organization_id,
      event: 'send invoice',
      properties: invoice_properties(include_payment_link)
    )
    @invoice.update!(status: 'posted')
  end

  def charge!
    compatible_methods = @invoice.customer.payment_methods.where(currency: @invoice.currency)
    if compatible_methods.any?
      begin
        kushki.charge(compatible_methods.first, @invoice)
      rescue PluttoErrors::PaymentError => e
        @invoice.update!(status: 'not_paid')
        raise e
      else
        @invoice.update!(status: 'paid')
      end
    else
      post!(true)
    end
  end

  def void!
    @invoice.update!(status: 'voided')
  end

  private

  def invoice_properties(include_payment_link)
    {
      invoice_date: @invoice.issue_date,
      invoice_total: { amount: @invoice.subtotal.amount, currency: @invoice.currency },
      details: @invoice.details,
      customer_email: @invoice.customer.email,
      customer_name: @invoice.customer.name,
      customer_organization: @invoice.customer.organization.name,
      billing_information: @invoice.customer.billing_information&.serializable_hash,
      payment_link: include_payment_link ? kushki.enroll_link_for(@invoice) : nil
    }
  end

  def kushki
    @kushki ||= KushkiService.new
  end
end
