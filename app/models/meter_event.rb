class MeterEvent < ApplicationRecord
  include PowerTypes::Observable

  belongs_to :meter
  belongs_to :meter_count
  belongs_to :billing_period, optional: true

  enum action: { increment: 0, set: 1, decrement: 2 }, _suffix: true

  validates :timestamp, presence: true

  delegate :customer, to: :meter_count
end

# == Schema Information
#
# Table name: meter_events
#
#  id                  :string           not null, primary key
#  timestamp           :datetime         not null
#  amount              :float            default(1.0)
#  action              :integer          default("increment")
#  meter_id            :string           not null
#  meter_count_id      :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  idempotency_key     :string
#  current_meter_count :float
#  billing_period_id   :string
#
# Indexes
#
#  index_meter_events_on_action             (action)
#  index_meter_events_on_billing_period_id  (billing_period_id)
#  index_meter_events_on_meter_count_id     (meter_count_id)
#  index_meter_events_on_meter_id           (meter_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#  fk_rails_...  (meter_count_id => meter_counts.id)
#  fk_rails_...  (meter_id => meters.id)
#
