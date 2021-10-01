RSpec.describe Pricing, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:pricing_subscriptions) }
    it { is_expected.to have_many(:price_logics) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'Validations' do
    it { is_expected.to define_enum_for(:currency).with_values(Currencies.keys) }
    it { is_expected.to validate_presence_of(:currency) }
  end
end
