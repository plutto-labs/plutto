class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :customers, dependent: :destroy

  validates :name, presence: true
  resourcify

  def enroll_user(user, role = :admin)
    user.organization = self
    user.save!
    user.add_role(role, self)
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
#
