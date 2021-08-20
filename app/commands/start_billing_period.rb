class StartBillingPeriod < PowerTypes::Command.new(:billing_period)
  def perform
    @billing_period.plan_version_price_logics.each do |price_logic|
      if price_logic.class.metered?
        MeterCount.create!(billing_period: @billing_period, meter: price_logic.meter)
      end
    end
  end
end
