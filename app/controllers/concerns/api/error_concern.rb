module Api::ErrorConcern
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      rescue_from 'Exception' do |exception|
        logger.error exception.message
        logger.error exception.backtrace.join('\n')
        Raven.capture_exception(exception)

        respond_unexpected_error
      end
    end

    rescue_from 'ActiveRecord::RecordNotFound' do |exception|
      respond_api_error(:not_found, message: 'record_not_found', detail: exception.message)
    end

    rescue_from 'ActiveModel::ForbiddenAttributesError' do |exception|
      respond_api_error(:bad_request, message: 'protected_attributes', detail: exception.message)
    end

    rescue_from 'ActiveRecord::RecordInvalid' do |exception|
      respond_api_error(:bad_request, message: 'invalid_attributes',
                         errors: exception.record.errors.full_messages)
    end
  end

  def respond_with_forbidden(_message = 'forbidden_action')
    respond_api_error(:forbidden, message: _message)
  end

  def respond_with_unauthorized(_message = 'apikey_authorization_failed')
    respond_api_error(:unauthorized, message: _message)
  end

  def respond_api_error(error, *_args)
    if error.is_a?(ApiException::BaseException)
      render json: error, serializer: Api::ExceptionSerializer, status: error.http_code

    else
      respond_unexpected_error
    end
  end

  private

  def respond_unexpected_error
    respond_api_error(ApiException::Errors::InternalServerError.new)
  end
end
