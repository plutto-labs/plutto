RSpec.describe PlanSubscription, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:billing_periods) }
    it { is_expected.to belong_to(:plan_version) }
    it { is_expected.to belong_to(:customer) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
