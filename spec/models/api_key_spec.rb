require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  before do
    allow(ENV).to receive(:fetch).with('API_KEY_HMAC_SECRET_KEY').and_return(
      'API_KEY_HMAC_SECRET_KEY'
    )
  end

  it 'has a valid factory' do
    expect(build(:api_key)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
