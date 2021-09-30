describe ProductPolicy do
  subject { described_class.new(user, product) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    it { is_expected.to forbid_actions([:create, :destroy, :show, :update]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:product) { create(:product, organization: organization) }
    let(:user) { create(:user, organization: organization) }

    it { is_expected.to permit_actions([:create, :destroy, :index, :show, :update]) }
  end
end
