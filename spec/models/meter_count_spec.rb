RSpec.describe MeterCount, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:billing_period) }
    it { is_expected.to belong_to(:meter) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_count) }
  end
end
