RSpec.describe Api::Internal::V1::PlansController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #index' do
    let(:organization) { create(:organization) }
    let!(:plan) { create(:plan, organization: organization) }
    let!(:plan2) { create(:plan, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :index, format: :json
        expect(response).to be_successful
      end

      it 'returns all plans' do
        get :index, format: :json
        expect(JSON.parse(response.body)['plans'].count).to eq(2)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #show' do
    let(:organization) { create(:organization) }
    let!(:plan) { create(:plan, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :show, format: :json, params: { id: plan.id }
        expect(response).to be_successful
      end
    end

    it_behaves_like 'unauthorized internal SHOW endpoint' do
      let(:resource_id) { plan.id }
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let!(:permission) { create(:permission) }
        let(:plan_params) do
          {
            plan: {
              name: 'Basic',
              price_currency: 'CLP',
              price: 10000,
              plan_permissions_attributes: [
                permission_id: permission.id
              ]
            }
          }
        end

        it 'returns http success' do
          post :create, format: :json, params: plan_params
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end
end
