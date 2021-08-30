describe PlanSubscriptionService do
  let(:plan_subscription) { create(:plan_subscription) }
  let(:service) { described_class.new(plan_subscription: plan_subscription) }
  let(:date) { DateTime.new(2021, 3, 20, 12, 0, 0) }
  let!(:billing_period) do
    create(:billing_period, plan_subscription: plan_subscription, from: date - 1.month, to: date)
  end

  before do
    Timecop.freeze(date)
    allow(StartBillingPeriod).to receive(:for).and_return(usd(100))
  end

  describe '#end_billing_period' do
    before do
      allow(BillingPeriodPriceCalculator).to receive(:for).and_return(usd(100))
    end

    it 'set the current Date as billing_date' do
      expect { service.end_billing_period }.to change { billing_period.reload.billing_date }
        .from(nil).to(date)
    end

    it 'gets the current billing amount' do
      service.end_billing_period

      expect(BillingPeriodPriceCalculator).to have_received(:for).with(
        billing_period: billing_period
      )
    end

    it 'sets the billing_amount' do
      expect { service.end_billing_period }.to change { billing_period.reload.billing_amount }
        .from(usd(0)).to(usd(100))
    end
  end

  describe '#initialize_next_billing_period' do
    it 'creates the next billing period' do
      expect { service.end_billing_period }.to change { plan_subscription.billing_periods.count }
        .by(1)
    end

    it 'call StartBillingPeriod command' do
      service.end_billing_period
      expect(StartBillingPeriod).to have_received(:for)
        .with(billing_period: plan_subscription.billing_periods.last)
    end
  end
end
