class PlanSubscriptionPolicy < OrganizationRelatedPolicy
  private

  def organization_id
    @record.plan_version.plan.organization_id
  end
end
