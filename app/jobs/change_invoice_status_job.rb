class ChangeInvoiceStatusJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(invoice, status)
    invoice.change_status!(status)
  end
end
