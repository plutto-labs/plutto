require 'rails_helper'

describe StartNewBillingPeriod do
  let(:plan_subscription) { create(:plan_subscription) }
  let(:billing_period) { create(:billing_period, plan_subscription: plan_subscription) }
  let(:new_billing_period) { instance_double(BillingPeriod) }
  let(:date) { billing_period.to + 1.day }

  def perform
    described_class.for(plan_subscription: plan_subscription, billing_period: billing_period)
  end

  describe '#perform' do
    before do
      allow(BillingPeriod).to receive(:create).and_return(new_billing_period)
      allow(SetInitialDataToBillingPeriod).to receive(:for)
        .with(billing_period: new_billing_period)
        .and_return(true)
      allow(CreateInvoice).to receive(:for).with(billing_period: new_billing_period)
    end

    it 'creates the next billing period' do
      perform
      expect(BillingPeriod).to have_received(:create)
        .with(
          from: date,
          to: date + plan_subscription.billing_period_duration,
          plan_subscription: plan_subscription
        )
    end

    it 'call StartBillingPeriod command' do
      perform
      expect(SetInitialDataToBillingPeriod).to have_received(:for)
        .with(billing_period: new_billing_period)
    end

    context 'when plan bills at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(true)
      end

      it 'calls CreateInvoice command' do
        perform
        expect(CreateInvoice).to have_received(:for).with(billing_period: new_billing_period)
      end
    end

    context 'when plan does not bill at start' do
      before do
        allow(plan_subscription).to receive(:bills_at_start?).and_return(false)
      end

      it 'does not call CreateInvoice command' do
        perform
        expect(CreateInvoice).not_to have_received(:for)
      end
    end
  end
end
