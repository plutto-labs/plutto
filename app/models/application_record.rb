class ApplicationRecord < ActiveRecord::Base
  include IdGenerator

  self.abstract_class = true
  self.implicit_order_column = 'created_at'

  before_create :generate_id
  validates :id, uniqueness: true

  private

  def generate_id
    raise NotImplementedError
  end
end
