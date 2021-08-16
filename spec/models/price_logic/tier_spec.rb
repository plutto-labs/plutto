require 'rails_helper'

RSpec.describe PriceLogic::Tier, type: :model do
  it 'has a valid factory' do
    expect(build(:price_logic_tier)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:tierable) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:upper_limit) }
    it { is_expected.to validate_presence_of(:lower_limit) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_presence_of(:index) }
  end

  it { is_expected.to monetize(:price_cents) }

  describe '#units_in_tier' do
    context 'with upper_limit present' do
      it 'returns the correct number of units' do
        tier = create(:price_logic_tier, lower_limit: 5, upper_limit: 10)
        expect(tier.units_in_tier).to eq(5)
      end
    end

    context 'with upper_limit not present' do
      it 'return infinity' do
        tier = create(:price_logic_tier, lower_limit: 5, upper_limit: Float::INFINITY)
        expect(tier.units_in_tier).to eq(Float::INFINITY)
      end
    end
  end
end
