require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:organization).optional }
  end
end
