class Api::V1::CustomerPolicy < Api::V1::ApiPolicy
  def permission?
    true
  end

  def permissions?
    true
  end
end
