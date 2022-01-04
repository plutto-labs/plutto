class BillingPeriodPriceDetails < PowerTypes::Command.new(:organization_id, :date)
  # rubocop:disable Rails/SkipsModelValidations
  def perform
    # Watch out for duplicated billing periods.
    billing_periods.each do |billing_period|
      billing_period.invoice.destroy!
      billing_period.update_columns(billing_date: nil)
      billing_period.billing_period_meter_datas.update_all(final_count: nil)
      EndBillingPeriodJob.perform_later(billing_period)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

  def billing_periods
    @billing_periods ||= Invoice.joins(:customer)
                                .where('customer.organization_id': @organization_id)
                                .where('DATE(invoices.created_at) = ?', @date)
                                .map(&:billing_period)
  end
end
