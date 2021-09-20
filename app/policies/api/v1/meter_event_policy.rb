class Api::V1::MeterEventPolicy < Api::V1::ApiPolicy
  def create?
    true
  end
end
