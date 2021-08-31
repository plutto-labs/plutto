require 'swagger_helper'

describe 'API V1 Customers', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/customers' do
    get 'Retrieves Customers' do
      tags 'Customers'
      description 'Retrieves all the customers'
      produces 'application/json'
      security [Bearer: {}]

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before { create_list(:customer, collection_count, organization: organization) }

      response '200', 'Customers retrieved' do
        schema('$ref' => '#/definitions/customers_collection')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          expect(JSON.parse(response.body)['customers'].count).to eq(expected_collection_count)
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end

    post 'Creates Customer' do
      tags 'Customers'
      description 'Creates Customer'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :customer, in: :body, schema: { '$ref': '#/definitions/customer_create' }

      let(:customer) do
        {
          email: 'donald@getplutto.com',
          name: 'Plutto Donald'
        }
      end

      response '201', 'customer created' do
        schema('$ref' => '#/definitions/customer_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          customer = JSON.parse(response.body)['customer']
          expect(customer['name']).to eq('Plutto Donald')
          expect(customer['id']).to be_present
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/customers/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:existent_customer) { create(:customer, organization: organization) }
    let(:id) { existent_customer.identifier }

    get 'Retrieves Customer' do
      tags 'Customers'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'customer retrieved' do
        schema('$ref' => '#/definitions/customer_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      response '404', 'invalid customer id' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 'invalid' }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end

    patch 'Updates Customer' do
      tags 'Customers'
      description 'Updates Customer'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :customer, in: :body, schema: { '$ref': '#/definitions/meter_event_create' }

      let(:customer) do
        {
          email: 'planet@getplutto.com',
          name: 'Plutto Planet'
        }
      end

      response '200', 'customer updated' do
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end

    delete 'Deletes Customer' do
      tags 'Customers'
      produces 'application/json'
      description 'Deletes specific customer'
      security [Bearer: {}]

      response '204', 'customer deleted' do
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response '404', 'customer not found' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 'invalid' }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end
