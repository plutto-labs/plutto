RSpec.describe BillingPeriodMeterData, type: :model do
  let(:billing_period_meter_data) { create(:billing_period_meter_data) }

  describe 'Relations' do
    it { expect(billing_period_meter_data).to belong_to(:billing_period) }
    it { expect(billing_period_meter_data).to belong_to(:meter_count) }
  end

  describe 'Validations' do
    it { expect(billing_period_meter_data).to validate_presence_of(:billing_period) }
    it { expect(billing_period_meter_data).to validate_presence_of(:meter_count) }

    it do
      expect(billing_period_meter_data)
        .to validate_uniqueness_of(:meter_count_id).scoped_to(:billing_period_id)
    end
  end
end
