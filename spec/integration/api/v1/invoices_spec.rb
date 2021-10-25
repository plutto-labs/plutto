require 'swagger_helper'

describe 'API V1 Invoices', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }
  let(:customer) { create(:customer, organization: organization) }

  path '/api/v1/invoices' do
    get 'Retrieves Invoices' do
      tags 'Invoices'
      description 'Retrieves all the invoices'
      produces 'application/json'
      parameter name: :'q[status_eq]', in: :query, schema: { type: :string }, required: false,
                description: 'Search by status'
      parameter name: :'q[customer_eq]', in: :query, schema: { type: :string }, required: false,
                description: 'Search by customer'
      security [Bearer: []]

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before do
        create_list(:invoice, collection_count, customer: customer,
                              billing_information: customer.billing_information.as_json,
                              status: 'paid')
      end

      response '200', 'Invoices retrieved' do
        schema('$ref' => '#/components/schemas/invoices_collection')
        let(:Authorization) { "Bearer #{token}" }

        context 'when no filters are sent' do
          run_test! do |response|
            expect(JSON.parse(response.body)['invoices'].count).to eq(expected_collection_count)
          end
        end

        context 'when status filters are sent' do
          let(:'q[status_eq]') { 'created' }

          before { create(:invoice, customer: customer, status: 'created') }

          run_test! do |response|
            expect(JSON.parse(response.body)['invoices'].count).to eq(1)
            expect(JSON.parse(response.body)['invoices'][0]['status']).to eq('created')
          end
        end

        context 'when customer filters are sent' do
          let!(:filtering_customer) { create(:customer, organization: organization) }
          let(:'q[customer_eq]') { filtering_customer.identifier }

          before { create(:invoice, customer: filtering_customer) }

          run_test! do |response|
            expect(JSON.parse(response.body)['invoices'].count).to eq(1)
            expect(JSON.parse(response.body)['invoices'][0]['customer_id']).to eq(
              filtering_customer.id
            )
          end
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/api/v1/invoices/{id}' do
    parameter name: :id, in: :path, schema: { type: :integer }

    let(:existent_invoice) { create(:invoice, customer: customer) }
    let(:id) { existent_invoice.id }

    get 'Retrieves Invoice' do
      tags 'Invoices'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'invoice retrieved' do
        schema('$ref' => '#/components/schemas/invoice_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end
  end
end
