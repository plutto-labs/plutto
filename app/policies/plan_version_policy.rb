class PlanVersionPolicy < OrganizationRelatedPolicy
  class Scope < Scope
    def resolve
      scope.joins(:plan).where(plans: { organization_id: organization_id })
    end
  end

  private

  def organization_id
    @record.plan.organization_id
  end
end
