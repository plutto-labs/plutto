class MeterCount < ApplicationRecord
  include IdentifierAttribute

  belongs_to :billing_period
  belongs_to :meter

  has_many :meter_events, dependent: :nullify

  validates :identifier, uniqueness: true

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
#  id                :bigint(8)        not null, primary key
#  count             :float            default(0.0)
#  identifier        :string
#  billing_period_id :bigint(8)        not null
#  meter_id          :bigint(8)        not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_meter_counts_on_billing_period_id  (billing_period_id)
#  index_meter_counts_on_identifier         (identifier) UNIQUE
#  index_meter_counts_on_meter_id           (meter_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#  fk_rails_...  (meter_id => meters.id)
#
