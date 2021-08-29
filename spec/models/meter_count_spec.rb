RSpec.describe MeterCount, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:meter) }
    it { is_expected.to have_many(:billing_period_meter_datas) }
  end

  describe 'Validations' do
    let(:meter_count) { create(:meter_count) }

    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_presence_of(:meter_id) }
    it { expect(meter_count).to validate_uniqueness_of(:customer_id).scoped_to(:meter_id) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_count) }
  end
end
