describe SubscriptionPolicy do
  subject { described_class.new(user, subscription) }

  context 'when user doesn`t belongs to organization' do
    let(:user) { create(:user) }
    let(:subscription) { create(:subscription) }

    it { is_expected.to forbid_actions([:create, :edit_trial]) }
  end

  context 'when user belongs to organization' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:customer) { create(:customer, organization: organization) }
    let(:subscription) { create(:subscription, customer: customer) }

    it { is_expected.to permit_actions([:create, :edit_trial]) }
  end
end
