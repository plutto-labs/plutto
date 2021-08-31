RSpec.describe MeterEvent, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:meter_count) }
    it { is_expected.to belong_to(:billing_period).optional }
    it { is_expected.to belong_to(:meter) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:timestamp) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_event) }
  end
end
