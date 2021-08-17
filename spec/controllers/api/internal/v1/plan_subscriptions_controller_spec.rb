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

        it 'returns http success' do
          put :create, format: :json, params: {
            customer_id: customer.id, plan_version_id: plan_version.id
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

  describe 'DELETE #destroy' do
    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:organization) { create(:organization) }
        let(:plan) { create(:plan, organization: organization) }
        let(:plan_version) { create(:plan_version, plan: plan) }
        let!(:plan_subscription) { create(:plan_subscription, plan_version: plan_version) }

        it 'returns http success' do
          delete :destroy, format: :json, params: { id: plan_subscription.id }
          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when signed out' do
      let!(:plan_subscription) { create(:plan_subscription) }

      it 'returns http error' do
        delete :destroy, format: :json, params: { id: plan_subscription.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
