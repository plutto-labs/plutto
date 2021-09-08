require 'rails_helper'

describe EndBillingPeriod do
  let(:plan_subscription) { create(:plan_subscription) }
  let(:billing_period) { create(:billing_period, plan_subscription: plan_subscription) }
  let(:start_next_period) { true }
  let(:date) { Date.current }
  let(:bills_at_start) { true }

  def perform
    described_class.for(billing_period: billing_period, start_next_period: start_next_period)
  end

  describe '#perform' do
    before do
      allow(StartNewBillingPeriod).to receive(:for)
        .with(plan_subscription: plan_subscription, billing_period: billing_period)
        .and_return(true)
      allow(plan_subscription).to receive(:bills_at_start?).and_return(bills_at_start)
      allow(CreateInvoice).to receive(:for).with(
        billing_period: billing_period,
        customer: billing_period.plan_subscription.customer
      )
      allow(SetDataToBillingPeriod).to receive(:for)
        .with(billing_period: billing_period, count_type: 'final_count')
        .and_return(true)
    end

    it 'set the current Date as billing_date' do
      expect { perform }.to change { billing_period.reload.billing_date }
        .from(nil).to(date)
    end

    it 'call SetDataToBillingPeriod command' do
      perform
      expect(SetDataToBillingPeriod).to have_received(:for)
        .with(billing_period: billing_period, count_type: 'final_count')
    end

    context 'when called with start_new_period=true flag' do
      it 'initialize a new billing_period' do
        perform
        expect(StartNewBillingPeriod).to have_received(:for).with(
          plan_subscription: plan_subscription,
          billing_period: billing_period
        )
      end
    end

    context 'when called with start_new_period=false flag' do
      let(:start_next_period) { false }

      it 'does not initialize a new billing_period' do
        perform
        expect(StartNewBillingPeriod).not_to have_received(:for)
      end
    end

    context 'when plan does not bills at start' do
      let(:bills_at_start) { false }

      it 'calls CreateInvoice command' do
        perform
        expect(CreateInvoice).to have_received(:for).with(
          billing_period: billing_period,
          customer: billing_period.plan_subscription.customer
        )
      end
    end

    context 'when plan bill at start' do
      it 'does not call CreateInvoice command' do
        perform
        expect(CreateInvoice).not_to have_received(:for).with(
          billing_period: billing_period,
          customer: billing_period.plan_subscription.customer
        )
      end
    end
  end
end
