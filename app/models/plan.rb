class Plan < ApplicationRecord
  has_many :plan_permissions, dependent: :destroy
  has_many :permissions, through: :plan_permissions

  enum price_currency: Currencies.keys
  monetize :price_cents
  validates :price_currency, presence: true

  private

  def generate_id
    init_id('plan')
  end
end

# == Schema Information
#
# Table name: plans
#
#  id             :string           not null, primary key
#  name           :string
#  price_cents    :bigint(8)        default(0), not null
#  price_currency :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
