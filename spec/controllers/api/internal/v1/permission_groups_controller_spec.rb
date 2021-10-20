RSpec.describe Api::Internal::V1::PermissionGroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #index' do
    let(:organization) { create(:organization) }
    let!(:permission_group) { create(:permission_group, organization: organization) }
    let!(:permission_group2) { create(:permission_group, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :index, format: :json
        expect(response).to be_successful
      end

      it 'returns all permission_groups' do
        get :index, format: :json
        expect(JSON.parse(response.body)['permission_groups'].count).to eq(2)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #show' do
    let(:organization) { create(:organization) }
    let!(:permission_group) { create(:permission_group, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :show, format: :json, params: { id: permission_group.id }
        expect(response).to be_successful
      end
    end

    it_behaves_like 'unauthorized internal SHOW endpoint' do
      let(:resource_id) { permission_group.id }
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let!(:permission) { create(:permission) }
        let(:permission_group_params) do
          {
            permission_group: {
              name: 'Basic',
              price_currency: 'CLP',
              price: 10000,
              permission_group_permissions_attributes: [
                permission_id: permission.id
              ]
            }
          }
        end

        it 'returns http success' do
          post :create, format: :json, params: permission_group_params
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end

  describe 'PATCH #update' do
    let(:organization) { create(:organization) }
    let!(:permission_group) { create(:permission_group, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let!(:permission) { create(:permission) }
        let(:permission_group_params) do
          {
            permission_group: {
              name: 'Basic',
              price_currency: 'CLP',
              price: 10000,
              permission_group_permissions_attributes: [
                permission_id: permission.id
              ]
            }
          }
        end

        it 'returns http success' do
          patch :update, format: :json, params: permission_group_params.merge(
            id: permission_group.id
          )
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal PATCH endpoint' do
      let(:resource_id) { permission_group.id }
    end
  end

  describe 'DELETE #destroy' do
    let(:organization) { create(:organization) }
    let!(:permission_group) { create(:permission_group, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        it 'returns http success' do
          delete :destroy, format: :json, params: { id: permission_group.id }
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal DELETE endpoint' do
      let(:resource_id) { permission_group.id }
    end
  end
end
