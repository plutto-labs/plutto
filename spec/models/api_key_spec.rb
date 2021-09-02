require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  before do
    allow(ENV).to receive(:fetch).with('API_KEY_HMAC_SECRET_KEY').and_return(
      'API_KEY_HMAC_SECRET_KEY'
    )
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'token' do
    context 'when token is requested after create' do
      let(:api_key) { create(:api_key) }

      it { expect(api_key.token).not_to eq(nil) }
    end

    context 'when token is requested later' do
      let!(:api_key) { create(:api_key) }

      it { expect(described_class.find(api_key.id).token).to eq(nil) }
    end
  end

  describe '#serializable_hash' do
    let(:api_key) { create(:api_key) }

    it 'returns object without token_digest' do
      expect(api_key.serializable_hash({})).not_to include(:token_digest)
    end
  end

  describe '#self.authenticate_by_token!' do
    before do
      allow(SecureRandom).to receive(:hex).with(12)
      allow(SecureRandom).to receive(:hex).with(32).and_return(token)
    end

    let(:token) { 'token' }
    let!(:organization) { create(:organization) }
    let!(:api_key) { create(:api_key, token: token, bearer: organization) }

    context 'with valid token' do
      it { expect(described_class.authenticate_by_token!("sk_live_#{token}")).to eq(api_key) }
    end

    context 'with invalid token' do
      it do
        expect do
          described_class.authenticate_by_token!('api_key')
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
