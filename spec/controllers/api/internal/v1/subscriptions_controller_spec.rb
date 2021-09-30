RSpec.describe Api::Internal::V1::SubscriptionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'PUT #create' do
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with valid params' do
        let(:product) { create(:product, organization: organization) }
        let!(:pricing) { create(:pricing, product: product) }

        context 'with pricing param' do
          it 'returns http success' do
            post :create, format: :json,
              params: { customer_id: customer.id, pricing_ids: [pricing.id] }

            expect(response).to have_http_status(:success)
          end
        end
      end

      context 'with invalid params' do
        it 'returns http error' do
          post :create, format: :json, params: { customer_id: 0, pricing_ids: [] }
          expect(response).to have_http_status(:not_found)
        end

        context 'with incorrect pricing_ids' do
          let(:other_org_pricing) { create(:pricing) }

          it 'returns http not_found for pricing_id' do
            post :create, format: :json, params: {
              customer_id: customer.id, pricing_ids: [other_org_pricing.id]
            }

            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end

  describe 'PATCH #edit_trial' do
    let!(:subscription) do
      create(:subscription, customer: customer, trial_finishes_at: Date.current)
    end
    let(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    context 'when signed in' do
      before { sign_in create(:user, organization: organization) }

      context 'with start subscription param' do
        before do
          allow(StartNewBillingPeriod).to receive(:for).with(
            subscription: subscription,
            billing_period: nil
          )
        end

        it 'returns http success' do
          patch :edit_trial, format: :json,
            params: { subscription_id: subscription.id, start_subscription: true }

          expect(response).to have_http_status(:success)
          expect(StartNewBillingPeriod).to have_received(:for).with(
            subscription: subscription,
            billing_period: nil
          )
          expect(subscription.reload.trial_finishes_at).to eq(nil)
        end
      end

      context 'with trial_finishes_at param' do
        let(:new_trial_date) { Date.current + 1.day }

        it 'returns http success' do
          patch :edit_trial, format: :json,
            params: {
              subscription_id: subscription.id,
              trial_finishes_at: new_trial_date
            }

          expect(response).to have_http_status(:success)
          expect(subscription.reload.trial_finishes_at).to eq(new_trial_date)
        end
      end
    end

    it_behaves_like 'unauthorized internal POST endpoint'
  end
end