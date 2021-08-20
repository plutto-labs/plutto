RSpec.describe Plan, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_versions) }
    it { is_expected.to belong_to(:organization) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
