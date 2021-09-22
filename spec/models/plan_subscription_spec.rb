RSpec.describe PlanSubscription, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:billing_periods) }
    it { is_expected.to belong_to(:plan_version) }
    it { is_expected.to belong_to(:customer) }
  end

  describe '#end_subscription!' do
    let(:plan_subscription) { create(:plan_subscription, active: true) }

    it 'sets active to false' do
      expect(plan_subscription.active).to be_truthy
      plan_subscription.end_subscription!
      expect(plan_subscription.active).to be_falsey
    end

    context 'when plan subscription is inactive' do
      let(:plan_subscription) { create(:plan_subscription, active: false) }

      it 'raises a ActiveRecord::RecordInvalid error' do
        expect { plan_subscription.end_subscription! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#in_trial?' do
    let(:trial_finishes_at) { nil }
    let(:plan_subscription) do
      create(:plan_subscription, active: true, trial_finishes_at: trial_finishes_at)
    end

    context 'when trial_finishes_at is nil' do
      it { expect(plan_subscription.in_trial?).to eq(false) }
    end

    context 'when trial_finishes_at is a previous date' do
      let(:trial_finishes_at) { Date.current - 1.day }

      it { expect(plan_subscription.in_trial?).to eq(false) }
    end

    context 'when trial_finishes_at is today' do
      let(:trial_finishes_at) { Date.current }

      it { expect(plan_subscription.in_trial?).to eq(true) }
    end

    context 'when trial_finishes_at is a future date' do
      let(:trial_finishes_at) { Date.current + 1.day }

      it { expect(plan_subscription.in_trial?).to eq(true) }
    end
  end
end
