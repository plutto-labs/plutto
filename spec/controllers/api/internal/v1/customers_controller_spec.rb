RSpec.describe Api::Internal::V1::CustomersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #index' do
    let(:organization) { create(:organization) }
    let!(:customers) { create_list(:customer, 5, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :index, format: :json
        expect(response).to be_successful
      end

      it 'returns all customers' do
        get :index, format: :json
        expect(JSON.parse(response.body)['customers'].count).to eq(5)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #active' do
    let(:organization) { create(:organization) }

    before do
      customer1 = create(:customer, organization: organization)
      customer2 = create(:customer, organization: organization)
      create(:customer, organization: organization)
      create(:subscription, customer: customer1, active: true)
      create(:subscription, customer: customer2, active: true)
    end

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :active, format: :json
        expect(response).to be_successful
      end

      it 'returns only active customers' do
        get :active, format: :json
        expect(JSON.parse(response.body)['customers'].count).to eq(2)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #trial' do
    let(:organization) { create(:organization) }

    before do
      customer1 = create(:customer, organization: organization)
      customer2 = create(:customer, organization: organization)
      create(:customer, organization: organization)
      create(:subscription, customer: customer1, active: true, trial_finishes_at: Date.current)
      create(:subscription, customer: customer2, active: true, trial_finishes_at: Date.current)
    end

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :trial, format: :json
        expect(response).to be_successful
      end

      it 'returns only customers with active trial' do
        get :trial, format: :json
        expect(JSON.parse(response.body)['customers'].count).to eq(2)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #show' do
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :show, format: :json, params: { id: customer.id }
        expect(response).to be_successful
      end
    end

    it_behaves_like 'unauthorized internal SHOW endpoint' do
      let(:resource_id) { customer.id }
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }
    let(:pricing_ids) { nil }
    let(:customer_params) do
      { customer: {
        email: 'donald@getplutto.com',
        name: 'Donald',
        identifier: 'your-id_12885305',
        billing_information: {
          city: 'Santiago',
          country_iso_code: 'CHL',
          state: 'Metropolitana',
          address: 'Av. Las Condes',
          zip: '12345',
          tax_id: '73245432-1',
          legal_name: 'Plutto Inc',
          phone: '+56992680522'
        }
      } }
    end

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:product) { create(:product, organization: organization) }
        let!(:pricing_ids) { [create(:pricing, product: product).id] }

        it 'returns http success' do
          post :create, format: :json, params: customer_params
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end

  describe 'PUT #update' do
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }
    let(:customer_params) do
      { customer: {
        email: 'donald@getplutto.com',
        name: 'Donald',
        identifier: 'your-id_12885305',
        billing_information: {
          city: 'Santiago',
          country_iso_code: 'CHL',
          state: 'Metropolitana',
          address: 'Av. Las Condes',
          zip: '12345',
          tax_id: '73245432-1',
          legal_name: 'Plutto Inc',
          phone: '+56992680522'
        }
      } }
    end

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        it 'returns http success' do
          put :update, format: :json, params: customer_params.merge(id: customer.id)
          expect(response).to have_http_status(:success)
        end
      end
    end

    it_behaves_like 'unauthorized internal PATCH endpoint' do
      let(:resource_id) { customer.id }
    end
  end

  describe 'DELETE #destroy' do
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns http success' do
        delete :destroy, format: :json, params: { id: customer.id }
        expect(response).to have_http_status(:success)
      end
    end

    it_behaves_like 'unauthorized internal DELETE endpoint' do
      let(:resource_id) { customer.id }
    end
  end
end
