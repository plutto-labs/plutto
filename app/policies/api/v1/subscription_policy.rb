class Api::V1::SubscriptionPolicy < Api::V1::ApiPolicy
  def create?
    true
  end

  def end_subscription?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization.id })
    end
  end
end
