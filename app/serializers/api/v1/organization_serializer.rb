class Api::V1::OrganizationSerializer < Api::BaseSerializer
  attributes :widget_settings

  has_many :permission_groups
end
