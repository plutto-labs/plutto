class Api::V1::PlanVersionPolicy < Api::V1::ApiPolicy
  class Scope < Scope
    def resolve
      scope.joins(:plan).where(plans: { organization_id: organization.id })
    end
  end
end
