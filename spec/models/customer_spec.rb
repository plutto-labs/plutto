RSpec.describe Customer, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_subscriptions) }
    it { is_expected.to have_many(:meter_counts) }
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_one(:active_plan_subscription).conditions(active: true) }
    it { is_expected.to have_one(:billing_information) }
  end

  describe 'Validations' do
    let(:subject) { build(:customer) }

    describe 'when email is invalid' do
      let(:subject) { build(:customer, email: 'invalid_email@') }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'Callbacks' do
    context 'when identifier is not given' do
      let(:customer) { build(:customer, identifier: nil) }

      it 'generates identifier from id' do
        expect(customer.identifier).to eq(customer.id)
      end
    end

    context 'when identifier is given' do
      let(:customer) { build(:customer, identifier: 'customer-identifier') }

      it 'does not generate identifier' do
        expect(customer.identifier).to eq('customer-identifier')
      end
    end

    context 'when identifier is taken' do
      let!(:organization) { create(:organization) }
      let!(:customer) { create(:customer, identifier: 'customer-id', organization: organization) }
      let(:customer2) { build(:customer, identifier: 'customer-id', organization: organization) }

      it 'raises error when saving' do
        expect { customer2.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'add_plan_subscription' do
    let(:plan_version) { build(:plan_version) }
    let(:customer) { build(:customer) }

    before do
      allow(CreatePlanSubscription).to receive(:for)
        .with(plan_version: plan_version, customer: customer)
    end

    it 'calls CreatePlanSubscription' do
      customer.add_plan_subscription(plan_version)
      expect(CreatePlanSubscription).to have_received(:for)
        .with(plan_version: plan_version, customer: customer)
    end
  end
end
