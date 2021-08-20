require 'rails_helper'

RSpec.describe PriceLogic::Tier, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:tierable) }
  end

  describe 'Validations' do
    let(:tier) { build(:price_logic_tier) }

    it do
      expect(tier).to validate_numericality_of(:upper_limit)
        .is_greater_than_or_equal_to(tier.lower_limit)
    end

    it { is_expected.to validate_presence_of(:upper_limit) }
    it { is_expected.to validate_presence_of(:lower_limit) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_presence_of(:index) }
    it { is_expected.to validate_numericality_of(:lower_limit).is_greater_than_or_equal_to(0) }
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

  describe '#units_in_tier_range?' do
    let(:tier) { create(:price_logic_tier, lower_limit: 5, upper_limit: 10) }

    context 'when units are in tier range' do
      it 'returns true' do
        expect(tier).to be_units_in_tier_range(6)
      end
    end

    context 'when units are not in tier range' do
      it 'returns false' do
        expect(tier).not_to be_units_in_tier_range(3)
        expect(tier).not_to be_units_in_tier_range(20)
      end
    end
  end
end
