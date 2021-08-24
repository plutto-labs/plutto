RSpec.describe Api::Internal::V1::AuthController, type: :controller do
  describe 'create' do
    let(:organization) { create(:organization) }
    let!(:user) do
      create(
        :user,
        email: 'admin@example.com',
        password: '123123',
        organization: organization
      )
    end

    context 'with valid parameters' do
      before do
        allow(Analytics).to receive(:identify).with(user_id: user.id, traits: { email: user.email })
        allow(Analytics).to receive(:group).with(
          user_id: user.id,
          group_id: user.organization.id,
          traits: { organization_name: user.organization.name }
        )
      end

      let(:valid_params) do
        {
          email: 'admin@example.com',
          password: '123123'
        }
      end

      it 'logins correctly' do
        post :create, params: { auth: valid_params, format: :json }
        expect(response).to have_http_status :created
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          email: Faker::Internet.email,
          password: '12341234'
        }
      end

      it 'returns unauthorized' do
        post :create, params: { auth: invalid_params, format: :json }
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
