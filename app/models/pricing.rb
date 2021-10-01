class Pricing < ApplicationRecord
  has_many :pricing_subscriptions, dependent: :destroy
  has_many :price_logics, dependent: :destroy
  belongs_to :product

  accepts_nested_attributes_for :price_logics, allow_destroy: true

  delegate :meter, to: :product
  delegate :organization, to: :product

  validates :currency, presence: true

  enum currency: Currencies.keys

  private

  def generate_id
    init_id('pricing')
  end
end

# == Schema Information
#
# Table name: pricings
#
#  id         :string           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :string
#  currency   :integer
#
# Indexes
#
#  index_pricings_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
