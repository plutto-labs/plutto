class InvoiceService < PowerTypes::Service.new(:invoice)
  def post!
    Analytics.track(
      user_id: @invoice.customer.organization_id,
      event: 'send invoice',
      properties: invoice_properties
    )
    @invoice.update!(status: 'posted')
  end

  def charge!
    if @invoice.customer.payment_methods.any?
      begin
        kushki.charge(@invoice.customer.payment_methods.first, @invoice)
      rescue PluttoErrors::PaymentError => e
        @invoice.update!(status: 'not_paid')
        raise e
      else
        @invoice.update!(status: 'paid')
      end
    else
      post!
    end
  end

  private

  def post_if_configured
    settings = customer.organization.settings
    return unless settings

    if settings['charge_invoices_automatically']
      charge!
    elsif settings['send_invoices_automatically']
      post!
    end
  end

  def invoice_properties
    {
      invoice_date: @invoice.issue_date,
      invoice_total: { amount: @invoice.subtotal.amount, currency: @invoice.currency },
      details: @invoice.details,
      customer_email: @invoice.customer.email,
      customer_name: @invoice.customer.name,
      customer_organization: @invoice.customer.organization.name,
      billing_information: @invoice.customer.billing_information&.serializable_hash,
      payment_link: kushki.enroll_link_for(@invoice)
    }
  end

  def kushki
    @kushki ||= KushkiService.new
  end
end
