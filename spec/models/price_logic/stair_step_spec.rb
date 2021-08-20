RSpec.describe PriceLogic::StairStep, type: :model do
  it_behaves_like 'a price logic' do
    let(:subject) { build(:price_logic_stair_step) }
  end

  describe '#calculate_price' do
    let(:tier_prices) { [usd(300), usd(200), usd(100)] }
    let(:tiers_params) do
      [{ price: usd(300), limit: 100 }, { price: usd(200), limit: 200 },
       { price: usd(100), limit: 300 }]
    end
    let(:last_upper_limit) { 300 }
    let(:stair_step_logic) do
      create(:price_logic_stair_step, :with_tiers, price_cents: 100,
        price_currency: 'USD', tiers_params: tiers_params)
    end

    context 'when range is not from last tier' do
      let(:units) { 150 }

      it 'returns the correct price' do
        expected_price = tier_prices[1]
        expect(stair_step_logic.calculate_price(units)).to eq(expected_price)
      end
    end

    context 'when range is from last tier' do
      let(:units) { 300 }

      it 'returns the correct price' do
        expected_price = tier_prices[2]
        expect(stair_step_logic.calculate_price(units)).to eq(expected_price)
      end
    end

    context 'when the last tier is infinity' do
      let(:last_upper_limit) { Float::INFINITY }
      let(:units) { 500 }

      it 'returns the correct price' do
        expected_price = tier_prices[2]
        expect(stair_step_logic.calculate_price(units)).to eq(expected_price)
      end
    end
  end
end
