class LandingsController < ApplicationController
  layout 'landings'

  def invoicing
    Analytics.page(name: 'Invoicing', anonymous_id: request.remote_ip)
  end

  def send_invoice_email
    Analytics.identify(user_id: request.remote_ip, traits: { email: email_param })
    Analytics.track(
      user_id: request.remote_ip,
      event: 'send invoicing demo',
      properties: { email: email_param }
    )
    Analytics.flush

    redirect_to invoicing_path, notice: 'Email Sent   📪'
  end

  private

  def email_param
    @email_param ||= params.require(:email)
  end

  def service
    @service ||= AnalyticsService.new(organization: current_user.organization)
  end
end
