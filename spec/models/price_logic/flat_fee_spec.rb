RSpec.describe PriceLogic::FlatFee, type: :model do
  it 'has a valid factory' do
    expect(build(:per_unit)).to be_valid
  end

  it_behaves_like 'a price logic' do
    let(:subject) { build(:flat_fee) }
  end

  describe '#calculate_price' do
    let(:flat_fee) { create(:flat_fee, price_cents: 1000, price_currency: 'USD') }

    it 'returns a flat fee' do
      expect(flat_fee.calculate_price).to eq(usd(1000))
    end
  end
end
