class InvoiceObserver < PowerTypes::Observer
  after_create :send_if_configured

  def send_if_configured
    settings = object.customer.organization.settings
    return unless settings

    if settings.dig('charge_invoices_automatically')
      ChangeInvoiceStatusJob.set(wait: 1.minute).perform_later(object, 'charge')
    elsif settings.dig('send_invoices_automatically')
      ChangeInvoiceStatusJob.set(wait: 1.minute).perform_later(object, 'send')
    end
  end
end
