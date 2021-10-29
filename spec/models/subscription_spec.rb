RSpec.describe Subscription, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:billing_periods) }
    it { is_expected.to have_many(:pricing_subscriptions) }
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:permission_group).optional }
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
    let(:country_iso_code) { nil }
    let(:billing_information) { create(:billing_information, country_iso_code: country_iso_code) }
    let(:customer) { create(:customer, billing_information: billing_information) }
    let(:subscription) { create(:subscription, customer: customer, currency: 'USD') }
    let(:tax_rate) { 0.1 }

    context 'when country_iso_code is present' do
      let(:country_iso_code) { 'US' }

      before do
        allow(Countries).to receive(:find_by).with('iso2', country_iso_code)
                                             .and_return({ 'tax_rate' => tax_rate })
      end

      it { expect(subscription.tax_rate).to eq(tax_rate) }
    end

    context 'when country_iso_code is not present' do
      before do
        allow(Countries).to receive(:find_by)
          .with('iso2', country_iso_code).and_return(nil)
        allow(Countries).to receive(:find_by_currency)
          .with('USD').and_return({ 'tax_rate' => tax_rate })
      end

      it 'find country tax_rate using the country base_currency' do
        expect(subscription.tax_rate).to eq(tax_rate)
      end
    end
  end
end
