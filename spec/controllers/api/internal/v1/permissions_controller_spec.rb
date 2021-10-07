RSpec.describe Api::Internal::V1::PermissionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #index' do
    let(:organization) { create(:organization) }
    let!(:permission) { create(:permission, organization: organization) }
    let!(:permission2) { create(:permission, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :index, format: :json
        expect(response).to be_successful
      end

      it 'returns all permissions' do
        get :index, format: :json
        expect(JSON.parse(response.body)['permissions'].count).to eq(2)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        it 'returns http success if no meter nor meter_count_method' do
          params = { permission: { name: 'Dashboard' } }
          post :create, format: :json, params: params
          expect(response).to have_http_status(:success)
        end

        it 'returns http success if meter and meter_count_method' do
          meter = create(:meter)
          params = {
            permission: { name: 'Dashboard', meter_id: meter.id, meter_count_method: 'period_sum' }
          }
          post :create, format: :json, params: params
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid params' do
        it 'returns http 421 if meter but no meter_count_method' do
          meter = create(:meter)
          params = { permission: { name: 'Dashboard', meter_id: meter.id } }
          post :create, format: :json, params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns http 421 if no meter but meter_count_method is present' do
          params = { permission: { name: 'Dashboard', meter_count_method: 'period_sum' } }
          post :create, format: :json, params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end
end
