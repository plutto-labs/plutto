RSpec.describe Customer, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:subscriptions) }
    it { is_expected.to have_many(:meter_counts) }
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_many(:payment_methods) }
    it { is_expected.to have_one(:active_subscription).conditions(active: true) }
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

  describe 'add_subscription' do
    let(:pricings) { [build(:pricing)] }
    let(:customer) { build(:customer) }

    before do
      allow(CreateSubscription).to receive(:for)
        .with(pricings: pricings, customer: customer)
    end

    it 'calls CreateSubscription' do
      customer.add_subscription(pricings)
      expect(CreateSubscription).to have_received(:for)
        .with(pricings: pricings, customer: customer)
    end
  end

  describe 'previous_billing_period' do
    let(:customer) { create(:customer) }

    context 'when previous billing period is from the active subscription' do
      let(:subscription) { create(:subscription, customer: customer, active: true) }
      let!(:previous_billing_period) do
        create(:billing_period, created_at: Time.current - 1.month, subscription: subscription)
      end
      let!(:current_billing_period) do
        create(:billing_period, created_at: Time.current, subscription: subscription)
      end

      it { expect(customer.previous_billing_period).to eq(previous_billing_period) }
    end

    context 'when previous billing period is from previous subscription' do
      let(:previous_subscription) do
        create(
          :subscription,
          customer: customer,
          active: false,
          created_at: Time.current - 1.month
        )
      end
      let(:subscription) do
        create(:subscription, customer: customer, active: true, created_at: Time.current)
      end
      let!(:previous_billing_period) do
        create(
          :billing_period,
          created_at: Time.current - 1.month,
          subscription: previous_subscription
        )
      end
      let!(:current_billing_period) do
        create(:billing_period, created_at: Time.current, subscription: subscription)
      end

      it { expect(customer.previous_billing_period).to eq(previous_billing_period) }
    end
  end
end
