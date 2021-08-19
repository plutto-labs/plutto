describe PlanSubscriptionPolicy do
  subject { described_class.new(user, plan_subscription) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:plan_subscription) { create(:plan_subscription) }

    it { is_expected.to forbid_actions([:create]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:plan) { create(:plan, organization: organization) }
    let(:plan_version) { create(:plan_version, plan: plan) }
    let(:user) { create(:user, organization: organization) }
    let(:plan_subscription) { create(:plan_subscription, plan_version: plan_version) }

    it { is_expected.to permit_actions([:create]) }
  end
end
