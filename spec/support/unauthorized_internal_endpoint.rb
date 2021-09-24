RSpec.shared_examples 'unauthorized internal INDEX endpoint' do
  context 'when not signed in' do
    it 'returns a 401' do
      get :index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'unauthorized internal SHOW endpoint' do
  context 'when not signed in' do
    it 'returns a 401' do
      get :show, format: :json, params: { id: resource_id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'unauthorized internal POST endpoint' do
  context 'when not signed in' do
    it 'returns a 401' do
      post :create, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'unauthorized internal PATCH endpoint' do |action|
  context 'when not signed in' do
    it 'returns a 401' do
      action = action || :update
      put action, format: :json, params: { id: resource_id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'unauthorized internal DELETE endpoint' do
  context 'when not signed in' do
    it 'returns a 401' do
      delete :destroy, format: :json, params: { id: resource_id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
