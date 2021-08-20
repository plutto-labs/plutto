RSpec.describe PriceLogic::PerUnit, type: :model do
  it_behaves_like 'a price logic' do
    let(:subject) { build(:price_logic_per_unit) }
  end

  it_behaves_like 'a metered price logic'

  describe '#calculate_price' do
    let(:price_cent_per_unit) { 100 }
    let(:per_unit_logic) do
      create(:price_logic_per_unit, price_cents: price_cent_per_unit, price_currency: 'USD')
    end

    context 'when there are 0 units' do
      let(:units) { 0 }

      it 'returns 0' do
        expect(per_unit_logic.calculate_price(units)).to eq(usd(0))
      end
    end

    context 'when there are more than 1 units' do
      let(:units) { 10 }

      it 'returns the multiplication between price and n_units' do
        expect(per_unit_logic.calculate_price(units))
          .to eq(usd(price_cent_per_unit * units))
      end
    end
  end
end
