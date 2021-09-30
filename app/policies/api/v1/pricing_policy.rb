class Api::V1::PricingPolicy < Api::V1::ApiPolicy
  class Scope < Scope
    def resolve
      scope.joins(:product).where(products: { organization_id: organization.id })
    end
  end
end
