class Api::V1::OrganizationsController < Api::V1::BaseController
  def widget_settings
    # Internal use only. Widget require a valid API key to access.
    respond_with(organization)
  end
end
