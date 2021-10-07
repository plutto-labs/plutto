require 'swagger_helper'

describe 'API V1 Customers', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }
  let(:customer) do
    { email: 'donald@getplutto.com',
      name: 'Donald',
      identifier: 'your-id_12885305',
      billing_information: {
        city: 'Santiago',
        country_iso_code: 'CL',
        state: 'Metropolitana',
        address: 'Av. Las Condes',
        zip: '12345',
        tax_id: '73245432-1',
        legal_name: 'Plutto Inc',
        phone: '+56992680522'
      } }
  end

  path '/customers' do
    get 'Retrieves Customers' do
      tags 'Customers'
      description 'Retrieves all the customers'
      produces 'application/json'
      security [Bearer: []]

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
      security [Bearer: []]
      parameter name: :customer, in: :body, schema: { '$ref': '#/definitions/customer_create' }

      response '201', 'customer created' do
        schema('$ref' => '#/definitions/customer_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          customer = JSON.parse(response.body)['customer']
          expect(customer['id']).to be_present
          expect(customer['identifier']).to eq('your-id_12885305')
          expect(customer['billing_information']).to be_present
          expect(customer['billing_information']['legal_name']).to eq('Plutto Inc')
          expect(customer['billing_information']['country_iso_code']).to eq('CL')
        end
      end

      context 'when the identifier is duplicated' do
        before do
          create(:customer, organization: organization, identifier: 'your-id_12885305')
        end

        it_behaves_like 'unprocessable entity endpoint'
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/customers/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:existent_customer) { create(:customer, organization: organization) }
    let(:id) { existent_customer.id }

    get 'Retrieves Customer' do
      tags 'Customers'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'customer retrieved' do
        schema('$ref' => '#/definitions/customer_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end

    patch 'Updates Customer' do
      tags 'Customers'
      description 'Updates Customer'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :customer, in: :body, schema: { '$ref': '#/definitions/customer_create' }

      response '200', 'customer updated' do
        schema('$ref' => '#/definitions/customer_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          customer = JSON.parse(response.body)['customer']
          expect(customer['id']).to be_present
          expect(customer['billing_information']).to be_present
          expect(customer['identifier']).to eq('your-id_12885305')
          expect(customer['billing_information']['legal_name']).to eq('Plutto Inc')
          expect(customer['billing_information']['country_iso_code']).to eq('CL')
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end

    delete 'Deletes Customer' do
      tags 'Customers'
      produces 'application/json'
      description 'Deletes specific customer'
      security [Bearer: []]

      response '204', 'customer deleted' do
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/customers/{id}/has_permission/{permission_name}' do
    parameter name: :id, in: :path, type: :string
    parameter name: :permission_name, in: :path, type: :string

    let(:existent_customer) { create(:customer, organization: organization) }
    let(:id) { existent_customer.id }
    let(:permission) { create(:permission, organization: organization) }
    let(:permission_name) { permission.name }

    get 'Retrieves Customer permission' do
      tags 'Customers'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'customer retrieved' do
        schema('$ref' => '#/definitions/customer_permission_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end
  end
end
