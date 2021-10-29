RSpec.describe Api::Internal::V1::InvoicesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }

  describe 'GET #index' do
    let!(:invoices) { create_list(:invoice, 5, customer: customer) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :index, format: :json
        expect(response).to be_successful
      end

      it 'returns all invoices' do
        get :index, format: :json
        expect(JSON.parse(response.body)['invoices'].count).to eq(5)
      end
    end

    it_behaves_like 'unauthorized internal INDEX endpoint'
  end

  describe 'GET #show' do
    let!(:invoice) { create(:invoice, customer: customer) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response' do
        get :show, format: :json, params: { id: invoice.id }
        expect(response).to be_successful
      end
    end

    it_behaves_like 'unauthorized internal SHOW endpoint' do
      let(:resource_id) { invoice.id }
    end
  end

  describe 'PATCH #change_status' do
    let!(:invoice) { create(:invoice, customer: customer) }
    let(:event_params) { { event: 'post' } }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        it 'returns http success' do
          patch :change_status, format: :json,  params: event_params.merge(id: invoice.id)
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid params' do
        let(:event_params) { { event: 'destroy' } }

        before { patch :change_status, format: :json,  params: event_params.merge(id: invoice.id) }

        it 'returns http bad_request' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'wont perform destroy (or any other unvalid) action' do
          expect(Invoice.exists?(invoice.id)).to be(true)
        end
      end
    end

    it_behaves_like 'unauthorized internal PATCH endpoint', :change_status do
      let(:resource_id) { invoice.id }
    end
  end

  describe 'PATCH #mark_as' do
    let!(:invoice) { create(:invoice, customer: customer) }
    let(:event_params) { { event: 'posted' } }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        it 'returns http success' do
          patch :mark_as, format: :json,  params: event_params.merge(id: invoice.id)
          expect(response).to have_http_status(:success)
        end

        it 'marks invoice as' do
          patch :mark_as, format: :json,  params: event_params.merge(id: invoice.id)
          expect(invoice.reload.status).to eq('posted')
        end
      end

      context 'with invalid params' do
        let(:event_params) { { event: 'cualkier_status' } }

        before { patch :change_status, format: :json,  params: event_params.merge(id: invoice.id) }

        it 'returns http bad_request' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    it_behaves_like 'unauthorized internal PATCH endpoint', :change_status do
      let(:resource_id) { invoice.id }
    end
  end
end
