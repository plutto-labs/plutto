class PermissionPolicy < OrganizationRelatedPolicy
  private

  def organization_id
    @record.organization_id
  end
end