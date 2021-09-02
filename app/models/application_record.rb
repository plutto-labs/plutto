class ApplicationRecord < ActiveRecord::Base
  include IdGenerator

  self.abstract_class = true

  before_create :generate_id
  validates :id, uniqueness: true

  private

  def generate_id
    init_id(self.class.name.underscore.split('_')[-1])
  end
end
