class Api::V1::PlanSubscriptionPolicy < Api::V1::ApiPolicy
  def destroy?
    false
  end

  def index?
    false
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization.id })
    end
  end
end
