RSpec.describe Product, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:pricings) }
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to belong_to(:meter).optional }
  end
end
