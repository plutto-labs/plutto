RSpec.describe Customer, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:plan_subscriptions) }
    it { is_expected.to have_many(:meter_counts) }
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_one(:active_plan_subscription).conditions(active: true) }
    it { is_expected.to have_one(:billing_information) }
  end
end
