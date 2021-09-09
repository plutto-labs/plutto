RSpec.describe Api::Internal::V1::CustomersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'PUT #create' do
    let(:organization) { create(:organization) }
    let(:plan_version_id) { nil }
    let(:customer_params) do
      { customer: {
        email: 'donald@getplutto.com',
        name: 'Donald',
        plan_version_id: plan_version_id,
        identifier: 'your-id_12885305',
        billing_information: {
          city: 'Santiago',
          country_iso_code: 'CHL',
          state: 'Metropolitana',
          address: 'Av. Las Condes',
          zip: '12345',
          tax_id: '73245432-1',
          legal_name: 'Plutto Inc',
          phone: '+56992680522'
        }
      } }
    end

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:plan) { create(:plan, organization: organization) }
        let!(:plan_version_id) { create(:plan_version, plan: plan).id }

        it 'returns http success' do
          put :create, format: :json, params: customer_params

          expect(response).to have_http_status(:success)
        end
      end

      context 'without plan version params' do
        it 'returns only customer' do
          put :create, format: :json, params: customer_params

          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when signed out' do
      let!(:plan_version_id) { create(:plan_version).id }

      it 'returns http error' do
        put :create, format: :json, params: customer_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
