RSpec.describe PlanPermission, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:permission) }
  end
end
