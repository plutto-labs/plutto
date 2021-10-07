RSpec.describe Plan, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:plan_permissions) }
    it { is_expected.to have_many(:permissions) }
  end

  describe 'Validations' do
    it { is_expected.to define_enum_for(:price_currency).with_values(Currencies.keys) }
    it { is_expected.to validate_presence_of(:price_currency) }
    it { is_expected.to monetize(:price_cents) }
  end
end
