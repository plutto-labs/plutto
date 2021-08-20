RSpec.describe PriceLogic::FlatFee, type: :model do
  it_behaves_like 'a price logic' do
    let(:subject) { build(:price_logic_flat_fee) }
  end

  describe '#calculate_price' do
    let(:flat_fee_logic) { create(:price_logic_flat_fee, price_cents: 100, price_currency: 'USD') }

    it 'returns a flat fee' do
      expect(flat_fee_logic.calculate_price).to eq(usd(100))
    end
  end

  describe '.metered?' do
    it { expect(described_class).not_to be_metered }
  end
end
