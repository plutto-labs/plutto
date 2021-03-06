RSpec.describe Organization, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Relations' do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:meters) }
    it { is_expected.to have_many(:permission_groups) }
    it { is_expected.to have_many(:permissions) }
  end

  describe '#enroll_user' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }

    it 'adds user with desired role' do
      organization.enroll_user(user, :admin)
      expect(user.is_admin_of?(organization)).to be_truthy # rubocop:disable RSpec/PredicateMatcher
    end
  end

  describe '#email' do
    it 'returns the first user email'
  end
end
