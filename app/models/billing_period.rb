class BillingPeriod < ApplicationRecord
  has_many :meter_events, dependent: :destroy
  has_many :billing_period_meter_datas, dependent: :destroy
  has_one :invoice, dependent: :destroy
  belongs_to :subscription

  delegate :price_logics, to: :subscription

  private

  def generate_id
    init_id('period')
  end
end

# == Schema Information
#
# Table name: billing_periods
#
#  id              :string           not null, primary key
#  from            :datetime         not null
#  to              :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  billing_date    :datetime
#  subscription_id :string           not null
#
# Indexes
#
#  index_billing_periods_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_id => subscriptions.id)
#
