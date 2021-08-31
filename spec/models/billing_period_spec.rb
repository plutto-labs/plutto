RSpec.describe BillingPeriod, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:plan_subscription) }
    it { is_expected.to have_many(:billing_period_meter_datas) }
    it { is_expected.to have_one(:invoice) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:billing_period) }
  end
end
