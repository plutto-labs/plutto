class MeterCount < ApplicationRecord
  include IdentifierAttribute

  belongs_to :customer
  belongs_to :meter

  has_many :meter_events, dependent: :nullify
  has_many :billing_period_meter_datas, dependent: :destroy

  validates :meter, :customer, presence: true
  validates :identifier, uniqueness: true
  validates :customer_id, uniqueness: { scope: :meter_id }

  before_create :generate_identifier

  def update_count(event)
    case event.action
    when 'set'
      self.count = event.amount
    when 'increment'
      self.count += event.amount
    when 'decrement'
      self.count -= event.amount
    end
    save!
  end

  private

  def generate_identifier
    init_identifier('count')
  end
end

# == Schema Information
#
# Table name: meter_counts
#
#  id          :bigint(8)        not null, primary key
#  count       :float            default(0.0)
#  identifier  :string
#  meter_id    :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint(8)        not null
#
# Indexes
#
#  index_meter_counts_on_customer_id               (customer_id)
#  index_meter_counts_on_customer_id_and_meter_id  (customer_id,meter_id) UNIQUE
#  index_meter_counts_on_identifier                (identifier) UNIQUE
#  index_meter_counts_on_meter_id                  (meter_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (meter_id => meters.id)
#
