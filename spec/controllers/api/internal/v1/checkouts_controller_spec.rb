RSpec.describe Api::Internal::V1::CheckoutsController, type: :controller do
  describe 'GET #show' do
    context 'with invalid token' do
      it 'returns unauthorized response' do
        get :show, format: :json, params: { token: '1231' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with decryptable token' do
      before { allow(EncryptionService).to receive(:decrypt).and_return(key) }

      context 'with key=nil' do
        let(:key) { nil }

        it 'returns unauthorized response' do
          get :show, format: :json, params: { token: '1231' }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with bad_formatted key' do
        let(:key) { 'nosense_key' }

        it 'returns unauthorized response' do
          get :show, format: :json, params: { token: '1231' }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with correct key' do
        let(:customer) { create(:customer) }
        let(:key) { "customer|#{customer.id}" }

        it 'returns success response and record' do
          get :show, format: :json, params: { token: '1231', type: 'customer' }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['customer']['id']).to eq(customer.id)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with invalid token' do
      it 'returns unauthorized response' do
        put :update, format: :json, params: { token: '1231' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with decryptable token' do
      before { allow(EncryptionService).to receive(:decrypt).and_return(key) }

      context 'with key=nil' do
        let(:key) { nil }

        it 'returns unauthorized response' do
          put :update, format: :json, params: { token: '1231' }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with bad_formatted key' do
        let(:key) { 'nosense_key' }

        it 'returns unauthorized response' do
          put :update, format: :json, params: { token: '1231' }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with correct key' do
        let(:customer) { create(:customer) }
        let(:key) { "customer|#{customer.id}" }
        let(:record) do
          { id: customer.id, name: 'new-cool-name' }
        end

        it 'returns success response and updates record' do
          put :update, format: :json, params: { token: '1231', type: 'customer', record: record }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['customer']['name']).to eq('new-cool-name')
        end
      end
    end
  end
end
