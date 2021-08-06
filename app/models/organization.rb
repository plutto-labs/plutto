class Organization < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
  resourcify
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
