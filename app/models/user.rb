class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  acts_as_token_authenticatable

  belongs_to :organization, optional: true

  rolify strict: true

  after_save :identify_user

  def identify_user
    Analytics.identify(
      user_id: id,
      traits: { email: email, created_at: created_at }
    )
    if organization
      Analytics.group(
        user_id: id,
        group_id: organization.id,
        traits: { organization_name: organization.name }
      )
    end
  end

  private

  def generate_id
    init_id('user')
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :string           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :string
#  authentication_token   :string(30)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
