class ApplicationRecord < ActiveRecord::Base
  include IdGenerator

  self.abstract_class = true
  self.implicit_order_column = 'created_at'

  before_create :generate_id
  validates :id, uniqueness: true

  scope :ordered, -> { order(created_at: :desc) }

  private

  def generate_id
    raise NotImplementedError
  end
end
