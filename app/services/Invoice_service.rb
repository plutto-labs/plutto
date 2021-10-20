class InvoiceService < PowerTypes::Service.new(:invoice)
  def post!
    validate_transition!(@invoice.status, 'post')
    Analytics.track(
      user_id: @invoice.customer.organization_id,
      event: 'send invoice',
      properties: invoice_properties
    )
    @invoice.update!(status: 'posted')
  end

  def charge!
    validate_transition!(@invoice.status, 'charge')
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

  def void!
    validate_transition!(@invoice.status, 'void')
    @invoice.update!(status: 'voided')
  end

  private

  def validate_transition!(from, to)
    unless Invoice::VALID_ACTIONS[from.to_sym].include?(to.to_s)
      raise PluttoErrors::InvalidTransition, "Invoice can't change from #{from} to #{to}"
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
