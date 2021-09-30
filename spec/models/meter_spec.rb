RSpec.describe Meter, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:meter_events) }
    it { is_expected.to have_many(:meter_counts) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to belong_to(:organization) }
  end
end
