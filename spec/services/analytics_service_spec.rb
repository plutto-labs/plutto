describe AnalyticsService do
  def build(*_args)
    described_class.new(*_args)
  end

  def create_invoices(date, amount, status)
    create_list(:invoice, 2, customer: customer, created_at: date, subtotal_cents: amount,
                             status: status)
  end

  def create_customers(date)
    create_list(:customer, 2, created_at: date, organization: organization)
  end

  def create_subscriptions(date, with_billing_period = true)
    subscription = create(:subscription, customer: customer, created_at: date, active: true)
    create_list(:billing_period, 2, subscription: subscription, from: date) if with_billing_period
  end

  def create_billing_period(subscription, from, to)
    create(:billing_period, subscription: subscription, from: from, to: to)
  end

  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:service) { build(organization: organization) }

  before do
    Timecop.freeze(Time.zone.local(2021, 12, 1))
  end

  describe '#mrr_arr_per_month' do
    before do
      create_invoices(Date.new(2021, 7, 10), 10000, :paid)
      create_invoices(Date.new(2021, 7, 10), 10000, :not_paid)
      create_invoices(Date.new(2021, 8, 10), 20000, :paid)
      create_invoices(Date.new(2021, 8, 10), 20000, :not_paid)
      create_invoices(Date.new(2021, 9, 10), 30000, :paid)
      create_invoices(Date.new(2021, 9, 10), 30000, :not_paid)
    end

    it 'returns an object with mrr and arr' do
      expect(service.mrr_arr_per_month).to be_a(Hash)
      expect(service.mrr_arr_per_month).to have_key(:mrr)
      expect(service.mrr_arr_per_month).to have_key(:arr)
    end

    it 'returns mrr key with correct data' do
      expected_paid_result = {
        "Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0,
        "Jul": 20000, "Aug": 40000, "Sep": 60000, "Oct": 0, "Nov": 0, "Dec": 0
      }.to_h
      expect(service.mrr_arr_per_month[:mrr].keys)
        .to contain_exactly(:paid, :not_paid, :canceled, :created, :sent)
      expect(service.mrr_arr_per_month[:mrr][:paid].transform_keys(&:to_sym))
        .to eq(expected_paid_result)
    end
  end

  describe '#active_subscriptions_accumulated_per_month' do
    before do
      create_subscriptions(Date.new(2021, 7, 10))
      create_subscriptions(Date.new(2021, 8, 10))
      create_subscriptions(Date.new(2021, 9, 10), false)
    end

    it 'returns an object with active subscriptions per month' do
      expected_subscriptions_result = {
        "Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0,
        "Jul": 2, "Aug": 2, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0
      }.to_h

      expect(service.active_subscriptions_accumulated_per_month).to be_a(Hash)
      expect(service.active_subscriptions_accumulated_per_month.transform_keys(&:to_sym))
        .to eq(expected_subscriptions_result)
    end
  end

  describe '#customers_created_per_month' do
    before do
      create_customers(Date.new(2021, 7, 10))
      create_customers(Date.new(2021, 8, 10))
      create_customers(Date.new(2021, 9, 10))
    end

    it 'returns an object with customers created per month' do
      expected_customers_result = {
        "Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0,
        "Jul": 2, "Aug": 2, "Sep": 2, "Oct": 0, "Nov": 0, "Dec": 0
      }.to_h

      expect(service.customers_created_per_month).to be_a(Hash)
      expect(service.customers_created_per_month.transform_keys(&:to_sym))
        .to eq(expected_customers_result)
    end
  end

  describe '#numbers' do
    it 'returns a hash' do
      expect(service.numbers).to be_a(Hash)
      expect(service.numbers).to have_key(:churn_rate)
    end

    context 'when churned users is zero' do
      it 'returns correct churn rate value' do
        expect(service.numbers[:churn_rate]).to eq(0)
      end
    end

    context 'when churned users is not zero' do
      before do
        customers = create_customers(Date.current - 2.months)
        subscription = create(:subscription, customer: customer, active: true)
        subscription1 = create(:subscription, customer: customers[0], active: true)
        subscription2 = create(:subscription, customer: customers[1], active: true)
        create_billing_period(subscription, Date.current - 2.months, Date.current - 1.month)
        create_billing_period(subscription, Date.current - 1.month, Date.current)
        create_billing_period(subscription1, Date.current - 2.months, Date.current - 1.month)
        create_billing_period(subscription1, Date.current - 1.month, Date.current)
        create_billing_period(subscription2, Date.current - 2.months, Date.current - 1.month)
      end

      it 'returns correct churn rate value' do
        expect(service.numbers[:churn_rate]).to eq(33.33)
      end
    end
  end
end
