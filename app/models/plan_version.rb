class PlanVersion < ApplicationRecord
  has_many :plan_subscriptions, dependent: :destroy
  has_one :next_version, class_name: 'PlanVersion', dependent: :nullify,
    foreign_key: 'previous_version_id', inverse_of: :previous_version
  belongs_to :previous_version, class_name: 'PlanVersion', optional: true, inverse_of: :next_version
  belongs_to :plan

  has_one :determinant_plan, class_name: 'Plan', dependent: :nullify,
    foreign_key: :default_plan_version_id, inverse_of: :default_version

  has_many :price_logics, dependent: :destroy
  accepts_nested_attributes_for :price_logics, allow_destroy: true

  delegate :currency, to: :plan
  delegate :bills_at_start?, to: :plan
  delegate :billing_period_duration, to: :plan

  after_create :set_version

  private

  def set_version
    update_column(:version, previous_version&.version.to_i + 1)
  end

  def generate_id
    init_id('version')
  end
end

# == Schema Information
#
# Table name: plan_versions
#
#  id                  :string           not null, primary key
#  plan_id             :string           not null
#  previous_version_id :string
#  deployed            :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  version             :integer
#
# Indexes
#
#  index_plan_versions_on_plan_id              (plan_id)
#  index_plan_versions_on_previous_version_id  (previous_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#  fk_rails_...  (previous_version_id => plan_versions.id)
#
