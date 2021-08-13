RSpec.describe Meter, type: :model do
  it 'has a valid factory' do
    expect(build(:meter)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to have_many(:meter_events) }
    it { is_expected.to belong_to(:organization) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter) }
  end
end
