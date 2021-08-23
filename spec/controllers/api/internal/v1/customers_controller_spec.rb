RSpec.describe Api::Internal::V1::CustomersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'PUT #create' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:plan) { create(:plan, organization: organization) }
        let!(:plan_version) { create(:plan_version, plan: plan) }

        it 'returns http success' do
          put :create, format: :json, params: {
            customer: {
              name: 'customer', email: 'customer@example.com', plan_version_id: plan_version.id
            }
          }

          expect(response).to have_http_status(:success)
        end
      end

      context 'without plan version params' do
        it 'returns only customer' do
          put :create, format: :json, params: {
            customer: { name: 'customer', email: 'customer@example.com' }
          }

          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when signed out' do
      let!(:plan_version) { create(:plan_version) }

      it 'returns http error' do
        put :create, format: :json, params: {
          customer: {
            name: 'customer', email: 'customer@example.com', plan_version_id: plan_version.id
          }
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
