RSpec.describe Api::Internal::V1::PlanSubscriptionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'PUT #create' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let!(:customer) { create(:customer, organization: organization) }
        let(:plan) { create(:plan, organization: organization) }
        let!(:plan_version) { create(:plan_version, plan: plan) }

        it 'returns http success for plan_version_id' do
          put :create, format: :json, params: {
            customer_id: customer.id, plan_version_id: plan_version.id
          }

          expect(response).to have_http_status(:success)
        end

        it 'returns http success for plan_id' do
          plan.update(default_version: plan_version)
          put :create, format: :json, params: {
            customer_id: customer.id, plan_id: plan.id
          }

          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid params' do
        it 'returns http error' do
          put :create, format: :json, params: { customer_id: 0, plan_version_id: 0 }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when signed out' do
      let!(:customer) { create(:customer) }
      let!(:plan_version) { create(:plan_version) }

      it 'returns http error' do
        put :create, format: :json, params: {
          customer_id: customer.id, plan_version_id: plan_version.id
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
