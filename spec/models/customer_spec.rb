RSpec.describe Customer, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_subscriptions) }
    it { is_expected.to have_one(:active_plan_subscription).conditions(active: true) }
    it { is_expected.to have_many(:meter_events) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
