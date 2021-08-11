require 'rails_helper'

RSpec.describe MeterEvent, type: :model do
  it 'has a valid factory' do
    expect(build(:meter_event)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:meter_count) }
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:meter) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:timestamp) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_event) }
  end
end
