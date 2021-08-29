RSpec.describe MeterCount, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:meter) }
    it { is_expected.to have_many(:billing_period_meter_datas) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_count) }
  end
end
