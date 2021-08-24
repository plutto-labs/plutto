RSpec.describe PriceLogic::Tiered, type: :model do
  it_behaves_like 'a price logic' do
    let(:subject) { build(:price_logic_tiered) }
  end

  it_behaves_like 'a metered price logic'

  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:price_currency).in_array(CURRENCIES.keys) }
  end

  describe '#calculate_price' do
    let(:default_logic_price_cents) { 100 }
    let(:tiered_logic) do
      create(:price_logic_tiered, price_cents: default_logic_price_cents, price_currency: 'USD')
    end

    context 'when there are no tiers' do
      context 'when there are no units' do
        let(:units) { 0 }

        it 'returns 0' do
          expect(tiered_logic.calculate_price(units)).to eq(usd(0))
        end
      end

      context 'when there are more than 0 units' do
        let(:units) { 100 }

        it 'returns 0' do
          expect(tiered_logic.calculate_price(units)).to eq(usd(0))
        end
      end
    end

    context 'when there are tiers' do
      let(:tier_prices) { [usd(300), usd(200), usd(100)] }
      let(:last_upper_limit) { 300 }

      before do
        create(:price_logic_tier, tierable: tiered_logic, price: tier_prices[0],
                                  lower_limit: 0, upper_limit: 100)
        create(:price_logic_tier, tierable: tiered_logic, price: tier_prices[1],
                                  lower_limit: 101, upper_limit: 200)
        create(:price_logic_tier, tierable: tiered_logic, price: tier_prices[2],
                                  lower_limit: 201, upper_limit: last_upper_limit)
      end

      context 'when the last tier doesn`t get filled' do
        let(:units) { 150 }

        it 'returns the correct price' do
          expected_price = tier_prices[0] * 100 + tier_prices[1] * 50
          expect(tiered_logic.calculate_price(units)).to eq(expected_price)
        end
      end

      context 'when the last tier gets filled' do
        let(:units) { 300 }

        it 'returns the correct price' do
          expected_price = tier_prices[0] * 100 + tier_prices[1] * 99 + tier_prices[2] * 99
          expect(tiered_logic.calculate_price(units)).to eq(expected_price)
        end
      end

      context 'when the last tier is infinity' do
        let(:last_upper_limit) { Float::INFINITY }
        let(:units) { 500 }

        it 'returns the correct price' do
          expected_price = tier_prices[0] * 100 + tier_prices[1] * 99 + tier_prices[2] * 301
          expect(tiered_logic.calculate_price(units)).to eq(expected_price)
        end
      end
    end
  end
end
