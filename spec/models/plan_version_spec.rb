RSpec.describe PlanVersion, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_subscriptions) }
    it { is_expected.to have_one(:next_version) }
    it { is_expected.to belong_to(:previous_version).optional }
    it { is_expected.to belong_to(:plan) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
