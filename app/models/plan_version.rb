class PlanVersion < ApplicationRecord
  include IdentifierAttribute

  has_many :plan_subscriptions, dependent: :destroy
  has_one :next_version, class_name: 'PlanVersion', dependent: :nullify,
    foreign_key: 'previous_version_id', inverse_of: :previous_version
  belongs_to :previous_version, class_name: 'PlanVersion', optional: true, inverse_of: :next_version
  belongs_to :plan

  has_one :determinant_plan, class_name: 'Plan', dependent: :nullify,
    foreign_key: :default_plan_version_id, inverse_of: :default_version

  has_many :price_logics, dependent: :destroy
  accepts_nested_attributes_for :price_logics, allow_destroy: true

  validates :identifier, uniqueness: true

  delegate :currency, to: :plan

  before_create :generate_identifier
  after_create :set_version

  def human_version
    "V#{version} - #{created_at.strftime('%d %b %Y - %H:%M')}"
  end

  private

  def generate_identifier
    init_identifier('version')
  end

  def set_version
    update_column(:version, previous_version&.version.to_i + 1)
  end
end

# == Schema Information
#
# Table name: plan_versions
#
#  id                  :bigint(8)        not null, primary key
#  plan_id             :bigint(8)        not null
#  previous_version_id :bigint(8)
#  deployed            :boolean          default(FALSE)
#  identifier          :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  version             :integer
#
# Indexes
#
#  index_plan_versions_on_identifier           (identifier) UNIQUE
#  index_plan_versions_on_plan_id              (plan_id)
#  index_plan_versions_on_previous_version_id  (previous_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#  fk_rails_...  (previous_version_id => plan_versions.id)
#
