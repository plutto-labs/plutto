class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_param
    identifier
  end
end
