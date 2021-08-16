RSpec.describe PriceLogic::Volume, type: :model do
  it 'has a valid factory' do
    expect(build(:price_logic_volume)).to be_valid
  end

  it_behaves_like 'a price logic' do
    let(:subject) { build(:price_logic_volume) }
  end

  describe '#calculate_price' do
    let(:tier_prices) { [usd(300), usd(200), usd(100)] }
    let(:last_upper_limit) { 300 }
    let(:volume_logic) { create(:price_logic_volume, price_cents: 100, price_currency: 'USD') }

    before do
      create(:price_logic_tier, tierable: volume_logic, price: tier_prices[0],
                                lower_limit: 0, upper_limit: 100)
      create(:price_logic_tier, tierable: volume_logic, price: tier_prices[1],
                                lower_limit: 101, upper_limit: 200)
      create(:price_logic_tier, tierable: volume_logic, price: tier_prices[2],
                                lower_limit: 201, upper_limit: last_upper_limit)
    end

    context 'when range is not from last tier' do
      let(:units) { 150 }

      it 'returns the correct price' do
        expected_price = tier_prices[1] * 150
        expect(volume_logic.calculate_price(units)).to eq(expected_price)
      end
    end

    context 'when range is from last tier' do
      let(:units) { 300 }

      it 'returns the correct price' do
        expected_price = tier_prices[2] * 300
        expect(volume_logic.calculate_price(units)).to eq(expected_price)
      end
    end

    context 'when the last tier is infinity' do
      let(:last_upper_limit) { Float::INFINITY }
      let(:units) { 500 }

      it 'returns the correct price' do
        expected_price = tier_prices[2] * 500
        expect(volume_logic.calculate_price(units)).to eq(expected_price)
      end
    end
  end
end
