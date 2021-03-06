RSpec.describe PermissionGroup, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:permission_group_permissions) }
    it { is_expected.to have_many(:permissions) }
    it { is_expected.to have_many(:subscriptions) }
  end

  describe 'Validations' do
    it { is_expected.to define_enum_for(:price_currency).with_values(Currencies.keys) }
    it { is_expected.to validate_presence_of(:price_currency) }
    it { is_expected.to monetize(:price_cents) }
  end
end
