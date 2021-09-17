RSpec.describe Api::Internal::V1::PlanSubscriptionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'PUT #create' do
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:plan) { create(:plan, organization: organization) }
        let!(:plan_version) { create(:plan_version, plan: plan) }

        context 'with plan version param' do
          it 'returns http success' do
            post :create, format: :json,
              params: { customer_id: customer.id, plan_version_id: plan_version.id }

            expect(response).to have_http_status(:success)
          end
        end

        context 'with plan param' do
          before { plan.update(default_version: plan_version) }

          it 'returns http success' do
            post :create, format: :json,
              params: { customer_id: customer.id, plan_id: plan.id }

            expect(response).to have_http_status(:success)
          end
        end
      end

      context 'with invalid params' do
        it 'returns http error' do
          post :create, format: :json, params: { customer_id: 0, plan_version_id: 0 }
          expect(response).to have_http_status(:not_found)
        end

        context 'with incorrect plan_version_id' do
          let(:other_org_plan_version) { create(:plan_version) }

          it 'returns http not_found for plan_version_id' do
            post :create, format: :json, params: {
              customer_id: customer.id, plan_version_id: other_org_plan_version.id
            }

            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end
end
