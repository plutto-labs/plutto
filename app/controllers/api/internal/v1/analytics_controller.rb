class Api::Internal::V1::AnalyticsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def customers
    respond_with(build_response(service.customers_created_per_month))
  end

  def numbers
    respond_with(build_response(service.numbers))
  end

  def subscriptions
    respond_with(
      build_response(service.active_subscriptions_accumulated_per_month(currency_param))
    )
  end

  def mrr_and_arr
    respond_with(build_response(service.mrr_arr_per_month(currency_param)))
  end

  private

  def build_response(data)
    { data: data }
  end

  def service
    @service ||= AnalyticsService.new(organization: current_user.organization)
  end

  def currency_param
    params[:currency]
  end
end
