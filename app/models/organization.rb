class Organization < ApplicationRecord
  include IdentifierAttribute

  has_many :users, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :meters, dependent: :destroy
  has_many :api_keys, as: :bearer, dependent: :destroy

  validates :identifier, uniqueness: true
  validates :name, presence: true
  resourcify

  before_create :generate_identifier
  after_save :identify_organization

  def enroll_user(user, role = :admin)
    user.organization = self
    user.save!
    user.add_role(role, self)
  end

  private

  def identify_organization
    Analytics.identify(
      user_id:  "org_#{id}",
      traits: { name: name, created_at: created_at }
    )
  end

  def generate_identifier
    init_identifier('organization')
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :string           not null
#
# Indexes
#
#  index_organizations_on_identifier  (identifier) UNIQUE
#
