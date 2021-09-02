RSpec.describe MeterCount, type: :model do
  let(:meter_count) { create(:meter_count) }

  describe 'Relations' do
    it { expect(meter_count).to belong_to(:customer) }
    it { expect(meter_count).to belong_to(:meter) }
    it { expect(meter_count).to have_many(:billing_period_meter_datas) }
  end

  describe 'Validations' do
    it { expect(meter_count).to validate_presence_of(:customer) }
    it { expect(meter_count).to validate_presence_of(:meter) }
    it { expect(meter_count).to validate_uniqueness_of(:customer_id).scoped_to(:meter_id) }
  end
end
