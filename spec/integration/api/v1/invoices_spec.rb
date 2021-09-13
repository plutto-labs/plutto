require 'swagger_helper'

describe 'API V1 Invoices', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }
  let(:customer) { create(:customer, organization: organization) }

  path '/invoices' do
    get 'Retrieves Invoices' do
      tags 'Invoices'
      description 'Retrieves all the invoices'
      produces 'application/json'
      parameter name: :'q[status_eq]', in: :query, type: :string, required: false,
                description: 'Search query'
      security [Bearer: []]

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before { create_list(:invoice, collection_count, customer: customer, status: 'paid') }

      response '200', 'Invoices retrieved' do
        schema('$ref' => '#/definitions/invoices_collection')
        let(:Authorization) { "Bearer #{token}" }

        context 'when no filters are sent' do
          run_test! do |response|
            expect(JSON.parse(response.body)['invoices'].count).to eq(expected_collection_count)
          end
        end

        context 'when filters are sent' do
          let(:'q[status_eq]') { 'new' }

          before { create(:invoice, customer: customer, status: 'new') }

          run_test! do |response|
            expect(JSON.parse(response.body)['invoices'].count).to eq(1)
            expect(JSON.parse(response.body)['invoices'][0]['status']).to eq('new')
          end
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/invoices/{id}' do
    parameter name: :id, in: :path, type: :integer

    let(:existent_invoice) { create(:invoice, customer: customer) }
    let(:id) { existent_invoice.id }

    get 'Retrieves Invoice' do
      tags 'Invoices'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'invoice retrieved' do
        schema('$ref' => '#/definitions/invoice_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      response '404', 'invalid invoice id' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 'invalid' }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end