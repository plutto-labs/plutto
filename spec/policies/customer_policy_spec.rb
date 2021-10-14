describe CustomerPolicy do
  subject { described_class.new(user, customer) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:customer) { create(:customer) }

    it { is_expected.to forbid_actions([:create, :destroy]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:customer) { create(:customer, organization: organization) }
    let(:user) { create(:user, organization: organization) }

    it { is_expected.to permit_actions([:create, :destroy, :index, :show, :update]) }
  end
end
