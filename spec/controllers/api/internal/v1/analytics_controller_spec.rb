RSpec.describe Api::Internal::V1::AnalyticsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:analytics_service) do
    instance_double(AnalyticsService,
                    customers_created_per_month: {},
                    numbers: {},
                    active_subscriptions_accumulated_per_month: {},
                    mrr_arr_per_month: {})
  end

  before do
    allow(AnalyticsService).to receive(:new).and_return(analytics_service)
  end

  describe 'GET #customers' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response with customers' do
        get :customers, format: :json
        expect(response).to be_successful
        expect(analytics_service).to have_received(:customers_created_per_month)
      end
    end

    context 'when not signed in' do
      it 'returns a 401' do
        get :customers, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #numbers' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response with mrr_and_arr' do
        get :numbers, format: :json
        expect(response).to be_successful
        expect(analytics_service).to have_received(:numbers)
      end
    end

    context 'when not signed in' do
      it 'returns a 401' do
        get :mrr_and_arr, format: :json, params: { currency: 'USD' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #subscriptions' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response with subscriptions' do
        get :subscriptions, format: :json, params: { currency: 'USD' }
        expect(response).to be_successful
        expect(analytics_service).to have_received(:active_subscriptions_accumulated_per_month)
      end
    end

    context 'when not signed in' do
      it 'returns a 401' do
        get :subscriptions, format: :json, params: { currency: 'USD' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #mrr_and_arr' do
    let(:organization) { create(:organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      it 'returns a success response with mrr_and_arr' do
        get :mrr_and_arr, format: :json, params: { currency: 'USD' }
        expect(response).to be_successful
        expect(analytics_service).to have_received(:mrr_arr_per_month)
      end
    end

    context 'when not signed in' do
      it 'returns a 401' do
        get :mrr_and_arr, format: :json, params: { currency: 'USD' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
