class PricingSubscription < ApplicationRecord
  belongs_to :pricing
  belongs_to :subscription

  validate :no_metered_for_bills_at_start

  def price_logics
    pricing.price_logics
  end

  private

  def generate_id
    init_id('pricing_subscription')
  end

  def no_metered_for_bills_at_start
    if subscription&.bills_at_start? && pricing.price_logics &&
        pricing.price_logics.any?(&:metered?)
      errors.add(:pricing, 'Cannot bill at start of period if there is use-based price logics')
    end
  end
end

# == Schema Information
#
# Table name: pricing_subscriptions
#
#  id              :string           not null, primary key
#  pricing_id      :string           not null
#  subscription_id :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pricing_subscriptions_on_pricing_id       (pricing_id)
#  index_pricing_subscriptions_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (pricing_id => pricings.id)
#  fk_rails_...  (subscription_id => subscriptions.id)
#
