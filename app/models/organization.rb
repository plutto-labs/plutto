class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :permission_groups, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :subscriptions, through: :customers
  has_many :meters, dependent: :destroy
  has_many :invoices, through: :customers
  has_many :api_keys, as: :bearer, dependent: :destroy

  validates :name, presence: true
  resourcify

  after_save :identify_organization
  after_create :create_default_permission_group

  def enroll_user(user, role = :admin)
    user.organization = self
    user.save!
    user.add_role(role, self)
  end

  def email
    users.first.email
  end

  def public_api_key
    api_keys.find_or_create_by(name: 'public-api-key', category: 'pk')
  end

  private

  def identify_organization
    Analytics.identify(
      user_id:  id,
      traits: { name: name, created_at: created_at }
    )
  end

  def generate_id
    init_id('organization')
  end

  def create_default_permission_group
    permission = Permission.create!(name: 'users', organization: self)
    permission_groups.create!(
      name: 'Free',
      price: 0,
      price_currency: 'CLP',
      permission_group_permissions_attributes: [
        { permission_id: permission.id, limit: 10 }
      ]
    )
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id              :string           not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  settings        :jsonb
#  widget_settings :jsonb
#
