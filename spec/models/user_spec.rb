RSpec.describe User, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:organization).optional }
  end
end
