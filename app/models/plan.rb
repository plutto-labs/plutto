class Plan < ApplicationRecord
  has_many :plan_versions, dependent: :destroy
  belongs_to :organization
  belongs_to :default_version, class_name: 'PlanVersion', optional: true,
    foreign_key: 'default_plan_version_id', inverse_of: :determinant_plan

  enum currency: Currencies.keys
  enum bills_at: { start: 0, end: 1 }, _prefix: :bills_at
  attribute :billing_period_duration, :duration

  def add_plan_version(**params)
    plan_version = plan_versions.build(params.merge({ previous_version: default_version }))
    self.default_version = plan_version
    plan_version
  end

  private

  def generate_id
    init_id('plan')
  end
end

# == Schema Information
#
# Table name: plans
#
#  id                      :string           not null, primary key
#  name                    :string
#  organization_id         :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  default_plan_version_id :string
#  currency                :integer          default("USD"), not null
#  bills_at                :integer          default("start")
#  billing_period_duration :string
#
# Indexes
#
#  index_plans_on_default_plan_version_id  (default_plan_version_id)
#  index_plans_on_organization_id          (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_plan_version_id => plan_versions.id)
#  fk_rails_...  (organization_id => organizations.id)
#
