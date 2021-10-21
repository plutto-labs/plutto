class Api::V1::ProductPolicy < Api::V1::ApiPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: organization.id)
    end
  end
end
