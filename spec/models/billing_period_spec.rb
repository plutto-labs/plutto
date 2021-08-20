RSpec.describe BillingPeriod, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:plan_subscription) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:billing_period) }
  end
end
