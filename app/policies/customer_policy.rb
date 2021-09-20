class CustomerPolicy < OrganizationRelatedPolicy
  def active?
    index?
  end

  private

  def organization_id
    @record.organization_id
  end
end
