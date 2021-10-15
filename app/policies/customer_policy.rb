class CustomerPolicy < OrganizationRelatedPolicy
  def active?
    index?
  end

  def trial?
    index?
  end

  private

  def organization_id
    @record.organization_id
  end
end
