RSpec.describe Plan, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_versions) }
    it { is_expected.to belong_to(:organization) }
  end

  describe 'Validations' do
    describe '#no_metered_for_bills_at_start' do
      let(:bills_at) { 'start' }
      let(:plan) { build(:plan, bills_at: bills_at) }
      let(:plan_version) { create(:plan_version, plan: plan) }

      context 'when it bills at start' do
        it 'is not valid for metered price_logic' do
          plan_version.price_logics << create(:price_logic_stair_step)
          expect(plan.reload).not_to be_valid
        end

        it 'is valid for not metered price_logic' do
          plan_version.price_logics << create(:price_logic_flat_fee)
          expect(plan.reload).to be_valid
        end
      end

      context 'when it bills at end' do
        let(:bills_at) { 'end' }

        it 'is valid for metered price_logic' do
          plan_version.price_logics << create(:price_logic_stair_step)
          expect(plan.reload).to be_valid
        end

        it 'is valid for not metered price_logic' do
          plan_version.price_logics << create(:price_logic_flat_fee)
          expect(plan.reload).to be_valid
        end
      end
    end
  end

  describe '#tax_rate' do
    let(:plan) { create(:plan, country_iso_code: 'US') }
    let(:tax_rate) { 0.0 }

    before { allow(Countries).to receive(:find_by).with('US', 'tax_rate').and_return(tax_rate) }

    it 'returns the tax rate' do
      expect(plan.tax_rate).to eq(tax_rate)
    end
  end
end
