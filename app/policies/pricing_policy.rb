class PricingPolicy < OrganizationRelatedPolicy
  class Scope < Scope
    def resolve
      scope.joins(:product).where(products: { organization_id: organization_id })
    end
  end

  private

  def organization_id
    @record.product.organization_id
  end
end
