require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Relations' do
    let(:invoice) { create(:invoice) }

    it { expect(invoice).to belong_to(:billing_period) }
    it { expect(invoice).to belong_to(:customer) }
  end

  it { is_expected.to monetize(:subtotal_cents).with_model_currency(:currency) }
  it { is_expected.to monetize(:tax_cents).with_model_currency(:currency) }
  it { is_expected.to monetize(:discount_cents).with_model_currency(:currency) }
end
