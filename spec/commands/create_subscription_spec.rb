require 'rails_helper'

describe CreateSubscription do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:pricings) { create_list(:pricing, 2) }

  def perform(pricings, permission_group_id = nil)
    described_class.for(
      customer: customer,
      pricings: pricings,
      billing_period_duration: 'P1M',
      permission_group_id: permission_group_id
    )
  end

  describe '#perform' do
    before do
      allow(EndBillingPeriod).to receive(:for).and_return(true)
    end

    it 'creates a new subscription' do
      expect { perform(pricings) }.to change { customer.subscriptions.count }.by(1)
    end

    it 'creates a new subscription with active status' do
      subscription = perform(pricings)
      expect(subscription.active).to be_truthy
    end

    it 'returns the new Subscription' do
      expect(perform(pricings)).to be_a(Subscription)
    end

    context 'when permission_group is present' do
      let(:permission_group) { create(:permission_group, organization: organization) }

      it 'creates a new subscription with permission_group' do
        subscription = perform(pricings, permission_group.id)
        expect(subscription.permission_group_id).to eq(permission_group.id)
        expect(subscription.currency).to eq(permission_group.price_currency)
      end
    end

    context 'when permission_group is not present' do
      it 'creates a new subscription without permission_group' do
        subscription = perform(pricings)
        expect(subscription.permission_group_id).to eq(nil)
        expect(subscription.currency).to eq(pricings.first.currency)
      end
    end

    context 'when there is a previous active subscription' do
      let!(:subscription) do
        create(
          :subscription,
          customer: customer,
          active: true
        )
      end

      it 'changes the previous subscription to inactive' do
        expect { perform(pricings) }.to change {
          subscription.reload.active
        }.from(true).to(false)
      end

      it 'call EndBillingPeriod to end the current billing period' do
        perform(pricings)
        expect(EndBillingPeriod).to have_received(:for)
      end

      context 'when subscription already has one or more of product prices' do
        before do
          create(:pricing_subscription, subscription: subscription, pricing: pricings.first)
        end

        it do
          expect do
            perform(pricings)
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
