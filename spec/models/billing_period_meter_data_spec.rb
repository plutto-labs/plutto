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

  describe '#count' do
    let(:initial_count) { 10 }
    let(:final_count) { 30 }

    before do
      billing_period_meter_data.initial_count = initial_count
      billing_period_meter_data.final_count = final_count
      billing_period_meter_data.save
    end

    context 'when is a period_sum' do
      it 'returns the sum of the meter_counts' do
        expect(billing_period_meter_data.count('period_sum')).to eq 20
      end

      context 'when final count is negative' do
        let(:final_count) { 5 }

        it 'returns only a positive count' do
          expect(billing_period_meter_data.count('period_sum')).to eq(0)
        end
      end
    end

    context 'when is a history_sum' do
      it 'returns the sum of the meter_counts' do
        expect(billing_period_meter_data.count('history_sum')).to eq 30
      end
    end
  end
end
