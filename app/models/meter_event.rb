class MeterEvent < ApplicationRecord
  include IdentifierAttribute

  belongs_to :meter
  belongs_to :meter_count
  belongs_to :customer

  enum action: { increment: 0, set: 1, decrement: 2 }, _suffix: true

  validates :identifier, uniqueness: true
  validates :timestamp, presence: true

  before_create :generate_identifier

  private

  def generate_identifier
    init_identifier('event')
  end
end

# == Schema Information
#
# Table name: meter_events
#
#  id             :bigint(8)        not null, primary key
#  timestamp      :datetime         not null
#  amount         :float            default(1.0)
#  action         :integer          default("increment")
#  identifier     :string
#  meter_id       :bigint(8)        not null
#  customer_id    :bigint(8)        not null
#  meter_count_id :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_meter_events_on_action          (action)
#  index_meter_events_on_customer_id     (customer_id)
#  index_meter_events_on_identifier      (identifier) UNIQUE
#  index_meter_events_on_meter_count_id  (meter_count_id)
#  index_meter_events_on_meter_id        (meter_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (meter_count_id => meter_counts.id)
#  fk_rails_...  (meter_id => meters.id)
#
