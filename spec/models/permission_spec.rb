RSpec.describe Permission, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_one(:plan_permission) }
    it { is_expected.to have_one(:plan).through(:plan_permission) }
    it { is_expected.to belong_to(:meter).optional }
  end
end
