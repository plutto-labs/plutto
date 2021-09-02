RSpec.describe Plan, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_versions) }
    it { is_expected.to belong_to(:organization) }
  end
end
