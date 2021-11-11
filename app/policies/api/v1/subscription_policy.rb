class Api::V1::SubscriptionPolicy < Api::V1::ApiPolicy
  def create?
    secret_key?
  end

  def end_subscription?
    secret_key?
  end

  def add_pricings?
    secret_key?
  end

  def remove_pricings?
    secret_key?
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization.id })
    end
  end
end
