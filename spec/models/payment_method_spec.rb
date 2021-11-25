RSpec.describe PaymentMethod, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:customer) }
  end

  describe 'Validations' do
    it { is_expected.to define_enum_for(:gateway).with_values({ kushki: 0, mercadopago: 1 }) }
    it { is_expected.to define_enum_for(:category).with_values({ credit_card: 0 }) }
    it { is_expected.to define_enum_for(:currency).with_values(Currencies.keys) }
    it { is_expected.to define_enum_for(:card_brand).with_values({ mastercard: 0, visa: 1 }) }
  end
end
