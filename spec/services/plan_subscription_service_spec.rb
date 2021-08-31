describe PlanSubscriptionService do
  let(:plan_subscription) { create(:plan_subscription) }
  let(:service) { described_class.new(plan_subscription: plan_subscription) }
  let(:date) { DateTime.new(2021, 3, 20, 12, 0, 0) }

  before do
    Timecop.freeze(date)
    allow(StartBillingPeriod).to receive(:for).and_return(usd(100))
    allow(CreateInvoice).to receive(:for).with(billing_period: billing_period)
  end

  describe '#end_billing_period' do
    let!(:billing_period) do
      create(:billing_period, plan_subscription: plan_subscription, from: date - 1.month, to: date)
    end

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

    context 'when called with start_new_period=false flag' do
      before do
        allow(service).to receive(:initialize_next_billing_period)
      end

      it 'does not initialize a new billing_period' do
        service.end_billing_period(false)
        expect(service).not_to have_received(:initialize_next_billing_period)
      end
    end

    context 'when plan bills at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(true)
      end

      it 'calls CreateInvoice command' do
        service.end_billing_period(false)
        expect(CreateInvoice).not_to have_received(:for)
      end
    end

    context 'when plan does not bill at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(false)
      end

      it 'does not call CreateInvoice command' do
        service.end_billing_period(false)
        expect(CreateInvoice).to have_received(:for).with(billing_period: billing_period)
      end
    end
  end

  describe '#initialize_next_billing_period' do
    let(:billing_period) { instance_double(BillingPeriod) }

    before do
      allow(BillingPeriod).to receive(:create).and_return(billing_period)
    end

    it 'creates the next billing period' do
      service.initialize_next_billing_period
      expect(BillingPeriod).to have_received(:create)
        .with(from: date, to: date + 1.month, plan_subscription: plan_subscription)
    end

    it 'call StartBillingPeriod command' do
      service.initialize_next_billing_period
      expect(StartBillingPeriod).to have_received(:for)
        .with(billing_period: billing_period)
    end

    context 'when plan bills at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(true)
      end

      it 'calls CreateInvoice command' do
        service.initialize_next_billing_period
        expect(CreateInvoice).to have_received(:for).with(billing_period: billing_period)
      end
    end

    context 'when plan does not bill at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(false)
      end

      it 'does not call CreateInvoice command' do
        service.initialize_next_billing_period
        expect(CreateInvoice).not_to have_received(:for)
      end
    end
  end
end
