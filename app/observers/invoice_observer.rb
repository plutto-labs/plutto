class InvoiceObserver < PowerTypes::Observer
  after_create :post_if_configured

  def post_if_configured
    settings = object.customer.organization.settings
    return unless settings

    if settings['charge_invoices_automatically']
      object.change_status!('charge')
    elsif settings['send_invoices_automatically']
      object.change_status!('post')
    end
  end
end
