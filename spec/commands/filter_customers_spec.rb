describe FilterCustomers do
  def perform
    described_class.for(customers: organization.customers, options: options)
  end

  let(:organization) { create(:organization) }
  let!(:customer1) do
    create(:customer, name: 'Pedro Perez', email: 'pedro@perez.com', organization: organization)
  end

  let!(:customer2) do
    create(:customer, name: 'Juan Loyola', email: 'juan@gmail.com', organization: organization)
  end

  describe '#filter_customers' do
    context 'when search filter exists' do
      context 'when filter include all customers' do
        let(:options) { { search: '@' } }

        it { expect(perform).to eq(organization.customers) }
      end

      context 'when filter include one customer' do
        let(:options) { { search: 'juan' } }

        it { expect(perform).to eq([customer2]) }
      end
    end
  end
end
