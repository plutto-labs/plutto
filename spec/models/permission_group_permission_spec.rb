RSpec.describe PermissionGroupPermission, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:permission_group) }
    it { is_expected.to belong_to(:permission) }
  end
end
