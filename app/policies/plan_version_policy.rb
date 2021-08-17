class PlanVersionPolicy < OrganizationRelatedPolicy
  private

  def organization_id
    @record.plan.organization_id
  end
end
