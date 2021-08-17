describe PlanPolicy do
  subject { described_class.new(user, plan) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:plan) { create(:plan) }

    it { is_expected.to forbid_actions([:create, :destroy, :show, :update]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:plan) { create(:plan, organization: organization) }
    let(:user) { create(:user, organization: organization) }

    it { is_expected.to permit_actions([:create, :destroy, :index, :show, :update]) }
  end
end
