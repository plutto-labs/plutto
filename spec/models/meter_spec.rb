RSpec.describe Meter, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:meter_events) }
    it { is_expected.to have_many(:price_logics) }
    it { is_expected.to belong_to(:organization) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:meter_type) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter) }
  end
end
