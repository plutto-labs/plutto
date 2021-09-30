require 'rails_helper'

RSpec.describe PricingSubscription, type: :model do
  let(:pricing_subscription) { create(:pricing_subscription) }

  describe 'relations' do
    it { expect(pricing_subscription).to belong_to(:pricing) }
    it { expect(pricing_subscription).to belong_to(:subscription) }
  end

  describe '#no_metered_for_bills_at_start' do
    let(:pricing) { create(:pricing) }
    let(:subscription) { create(:subscription, bills_at: bills_at) }
    let(:pricing_subscription) do
      build(:pricing_subscription, pricing: pricing, subscription: subscription)
    end

    context 'when subscription bills at start' do
      let(:bills_at) { 'start' }

      it 'is not valid for metered price_logic' do
        pricing.price_logics << create(:price_logic_stair_step)
        expect(pricing_subscription).not_to be_valid
      end

      it 'is valid for not metered price_logic' do
        pricing.price_logics << create(:price_logic_flat_fee)
        expect(pricing_subscription).to be_valid
      end
    end

    context 'when subscription bills at end' do
      let(:bills_at) { 'end' }

      it 'is valid for metered price_logic' do
        pricing.price_logics << create(:price_logic_stair_step)
        expect(pricing_subscription).to be_valid
      end

      it 'is valid for not metered price_logic' do
        pricing.price_logics << create(:price_logic_flat_fee)
        expect(pricing_subscription).to be_valid
      end
    end
  end
end
