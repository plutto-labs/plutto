class ApiKeyPolicy < OrganizationRelatedPolicy
  private

  def organization_id
    @record.bearer_type == 'Organization' ? @record.bearer_id : nil
  end
end
