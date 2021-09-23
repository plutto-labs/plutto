describe PlanSubscriptionPolicy do
  subject { described_class.new(user, plan_subscription) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:plan_subscription) { create(:plan_subscription) }

    it { is_expected.to forbid_actions([:create, :edit_trial]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:customer) { create(:customer, organization: organization) }
    let(:plan_subscription) { create(:plan_subscription, customer: customer) }

    it { is_expected.to permit_actions([:create, :edit_trial]) }
  end
end
