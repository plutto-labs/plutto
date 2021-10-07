describe CustomerPermissionService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:customer) { create(:customer) }
  let(:meter) { create(:meter) }
  let(:permission) { create(:permission, meter: meter, meter_count_method: 1) }
  let(:plan_permission) { create(:plan_permission, permission: permission) }
  let(:service) do
    build(permission: permission, plan_permission: plan_permission, customer: customer)
  end

  describe '#plan_permission_limit' do
    context 'when plan permission not exist' do
      let(:plan_permission) { nil }

      it { expect(service.plan_permission_limit).to eq(nil) }
    end

    context 'when plan permission exist' do
      it { expect(service.plan_permission_limit).to eq(plan_permission.limit) }
    end
  end

  describe '#usage_for_current_period' do
    context 'when plan permission not exist' do
      let(:plan_permission) { nil }

      it { expect(service.usage_for_current_period).to eq(nil) }
    end

    context 'when plan permission exist' do
      before do
        meter_count = create(:meter_count, customer: customer, meter: meter)
        subscription = create(:subscription, customer: customer, active: true)
        billing_period = create(:billing_period, subscription: subscription)
        create(
          :billing_period_meter_data,
          billing_period: billing_period,
          meter_count: meter_count,
          final_count: 20
        )
      end

      it { expect(service.usage_for_current_period).to eq(20) }
    end
  end

  describe '#customer_allowed?' do
    context 'when plan permission not exist' do
      let(:plan_permission) { nil }

      it { expect(service.customer_allowed?).to eq(false) }
    end

    context 'when limit is nil' do
      before do
        allow(service).to receive(:plan_permission_limit).and_return(nil)
      end

      it { expect(service.customer_allowed?).to eq(true) }
    end

    context 'when plan permission exist and limit is not nil' do
      context 'when permission is metered' do
        before do
          allow(service).to receive(:plan_permission_limit).and_return(10)
          allow(service).to receive(:usage_for_current_period).and_return(9)
        end

        it { expect(service.customer_allowed?).to eq(true) }
      end

      context 'when permission is not metered' do
        before do
          allow(permission).to receive(:metered?).and_return(false)
        end

        it { expect(service.customer_allowed?).to eq(true) }
      end
    end
  end
end
