RSpec.describe MeterEvent, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:meter_count) }
    it { is_expected.to belong_to(:billing_period).optional }
    it { is_expected.to belong_to(:meter) }
  end

  describe 'Validations' do
    let(:meter_event) { build(:meter_event) }

    it { is_expected.to validate_presence_of(:timestamp) }
    it { is_expected.to validate_presence_of(:amount) }

    it do
      expect(meter_event).to validate_numericality_of(:amount)
        .is_greater_than_or_equal_to(0).with_message('must be greater than or equal to 0. Use ' \
          'decrement action to set a negative value')
    end
  end
end
