require 'rails_helper'

describe StartNewBillingPeriod do
  let(:subscription) { create(:subscription) }
  let(:billing_period) { create(:billing_period, subscription: subscription) }
  let(:new_billing_period) { instance_double(BillingPeriod) }
  let(:date) { billing_period.to + 1.day }

  def perform
    described_class.for(subscription: subscription, billing_period: billing_period)
  end

  describe '#perform' do
    before do
      allow(BillingPeriod).to receive(:create).and_return(new_billing_period)
      allow(SetDataToBillingPeriod).to receive(:for)
        .with(billing_period: new_billing_period, count_type: 'initial_count')
        .and_return(true)
      allow(CreateInvoice).to receive(:for).with(
        billing_period: new_billing_period,
        customer: billing_period.subscription.customer
      )
    end

    it 'creates the next billing period' do
      perform
      expect(BillingPeriod).to have_received(:create)
        .with(
          from: date,
          to: date + subscription.billing_period_duration - 1.day,
          subscription: subscription
        )
    end

    it 'call SetDataToBillingPeriod command' do
      perform
      expect(SetDataToBillingPeriod).to have_received(:for)
        .with(billing_period: new_billing_period, count_type: 'initial_count')
    end

    context 'when subscription bills at start' do
      before do
        allow(subscription).to receive(:bills_at_start?).and_return(true)
      end

      it 'calls CreateInvoice command' do
        perform
        expect(CreateInvoice).to have_received(:for).with(
          billing_period: new_billing_period,
          customer: billing_period.subscription.customer
        )
      end
    end

    context 'when subscription does not bill at start' do
      before do
        allow(subscription).to receive(:bills_at_start?).and_return(false)
      end

      it 'does not call CreateInvoice command' do
        perform
        expect(CreateInvoice).not_to have_received(:for)
      end
    end
  end
end
