RSpec.describe Permission, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:plan_permission) }
    it { is_expected.to have_many(:plan).through(:plan_permission) }
    it { is_expected.to belong_to(:meter).optional }
  end

  describe 'Validations' do
    let!(:permission) { create(:permission) }

    it { expect(permission).to validate_uniqueness_of(:name).scoped_to(:organization_id) }

    it 'validates presence of meter_count_method if meter_id present' do
      allow(permission).to receive(:meter_count_method).and_return(true)
      expect(permission).to validate_presence_of(:meter_id)
    end

    it 'validates presence of meter_id if meter_count_method present' do
      allow(permission).to receive(:meter_id).and_return(true)
      expect(permission).to validate_presence_of(:meter_count_method)
    end
  end
end
