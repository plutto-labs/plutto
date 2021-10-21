class ChargeInvoiceJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(invoice)
    invoice.change_status!('charge')
  end
end
