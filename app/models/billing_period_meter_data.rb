class BillingPeriodMeterData < ApplicationRecord
  belongs_to :billing_period
  belongs_to :meter_count

  validates :meter_count, :billing_period, presence: true
  validates :meter_count_id, uniqueness: { scope: :billing_period_id }

  def count
    case meter_count.meter.meter_type
    when 'period_sum'
      final_count - initial_count
    when 'history_sum'
      final_count
    end
  end

  private

  def generate_id
    init_id('period-meter-data')
  end
end

# == Schema Information
#
# Table name: billing_period_meter_data
#
#  id                :string           not null, primary key
#  initial_count     :float            default(0.0)
#  final_count       :float
#  billing_period_id :string           not null
#  meter_count_id    :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_billing_period_meter_data_on_billing_period_id  (billing_period_id)
#  index_billing_period_meter_data_on_meter_count_id     (meter_count_id)
#  index_on_meter_count_id_and_billing_period_id         (meter_count_id,billing_period_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#  fk_rails_...  (meter_count_id => meter_counts.id)
#
