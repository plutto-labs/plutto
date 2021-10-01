class Product < ApplicationRecord
  belongs_to :meter, optional: true
  belongs_to :organization
  has_many :pricings, dependent: :destroy

  def add_pricing(**params)
    pricings.build(params)
  end

  private

  def generate_id
    init_id('product')
  end
end

# == Schema Information
#
# Table name: products
#
#  id              :string           not null, primary key
#  name            :string
#  meter_id        :string
#  organization_id :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_products_on_meter_id         (meter_id)
#  index_products_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (meter_id => meters.id)
#  fk_rails_...  (organization_id => organizations.id)
#
