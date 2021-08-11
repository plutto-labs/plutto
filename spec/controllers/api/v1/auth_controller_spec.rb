RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'create' do
    let!(:user) { create(:user, email: 'admin@example.com', password: '123123') }

    context 'with valid parameters' do
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
