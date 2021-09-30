RSpec.describe Subscription, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:billing_periods) }
    it { is_expected.to have_many(:pricing_subscriptions) }
    it { is_expected.to belong_to(:customer) }
  end

  describe 'Validations' do
    describe '#trial_finishes_at_is_valid_datetime' do
      let(:trial_finishes_at) { 'not_date' }
      let(:subscription) { build(:subscription, trial_finishes_at: trial_finishes_at) }

      context 'when trial_finishes_at is not a valid date' do
        it do
          expect { subscription.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when trial_finishes_at is a valid date' do
        let(:trial_finishes_at) { Date.current }

        before do
          subscription.save!
        end

        it do
          expect(subscription).to be_valid
        end
      end
    end

    describe '#no_metered_for_bills_at_start' do
      let(:bills_at) { 'start' }
      let(:product) { build(:product) }
      let(:pricing) { create(:pricing, product: product) }
      let(:subscription) { build(:subscription, bills_at: bills_at) }
      let!(:pricing_subscription) do
        create(:pricing_subscription, pricing: pricing, subscription: subscription)
      end

      context 'when it bills at start' do
        it 'is not valid for metered price_logic' do
          pricing.price_logics << create(:price_logic_stair_step)
          expect(subscription.reload).not_to be_valid
        end

        it 'is valid for not metered price_logic' do
          pricing.price_logics << create(:price_logic_flat_fee)
          expect(subscription.reload).to be_valid
        end
      end

      context 'when it bills at end' do
        let(:bills_at) { 'end' }

        it 'is valid for metered price_logic' do
          pricing.price_logics << create(:price_logic_stair_step)
          expect(subscription.reload).to be_valid
        end

        it 'is valid for not metered price_logic' do
          pricing.price_logics << create(:price_logic_flat_fee)
          expect(subscription.reload).to be_valid
        end
      end
    end
  end

  describe '#end_subscription!' do
    let(:subscription) { create(:subscription, active: true) }

    it 'sets active to false' do
      expect(subscription.active).to be_truthy
      subscription.end_subscription!
      expect(subscription.active).to be_falsey
    end

    context 'when subscription is inactive' do
      let(:subscription) { create(:subscription, active: false) }

      it 'raises a ActiveRecord::RecordInvalid error' do
        expect { subscription.end_subscription! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#in_trial?' do
    let(:trial_finishes_at) { nil }
    let(:subscription) do
      create(:subscription, active: true, trial_finishes_at: trial_finishes_at)
    end

    context 'when trial_finishes_at is nil' do
      it { expect(subscription.in_trial?).to eq(false) }
    end

    context 'when trial_finishes_at is a previous date' do
      let(:trial_finishes_at) { Date.current - 1.day }

      it { expect(subscription.in_trial?).to eq(false) }
    end

    context 'when trial_finishes_at is today' do
      let(:trial_finishes_at) { Date.current }

      it { expect(subscription.in_trial?).to eq(true) }
    end

    context 'when trial_finishes_at is a future date' do
      let(:trial_finishes_at) { Date.current + 1.day }

      it { expect(subscription.in_trial?).to eq(true) }
    end
  end

  describe '#tax_rate' do
    let(:billing_information) { create(:billing_information, country_iso_code: 'US') }
    let(:customer) { create(:customer, billing_information: billing_information) }
    let(:subscription) { create(:subscription, customer: customer) }
    let(:tax_rate) { 0.0 }

    before { allow(Countries).to receive(:find_by).with('US', 'tax_rate').and_return(tax_rate) }

    it 'returns the tax rate' do
      expect(subscription.tax_rate).to eq(tax_rate)
    end
  end
end
