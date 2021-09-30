RSpec.describe Payment, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:invoice) }
    it { is_expected.to belong_to(:payment_method) }
  end

  describe 'Validations' do
    it { is_expected.to define_enum_for(:gateway).with_values({ kushki: 0 }) }
  end
end
