class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :meters, dependent: :destroy
  has_many :api_keys, as: :bearer, dependent: :destroy

  validates :name, presence: true
  resourcify

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

  def generate_id
    init_id('organization')
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id         :string           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
