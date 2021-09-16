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
      respond_api_error(ApiException::Errors::NotFound.new(detail:
        "Couldn't find #{exception.model} resource"))
    end

    rescue_from 'ActiveModel::ForbiddenAttributesError' do |exception|
      respond_api_error(ApiException::Errors::Forbidden.new(detail: exception.message))
    end

    rescue_from 'ActiveRecord::RecordInvalid' do |exception|
      respond_api_error(
        ApiException::Errors::UnprocessableEntity.new(
          detail: exception.record.errors.errors[0].type,
          param: exception.record.errors.errors[0].attribute
        )
      )
    end
  end

  def respond_with_forbidden
    respond_api_error(ApiException::Errors::Forbidden.new)
  end

  def respond_with_unauthorized
    respond_api_error(ApiException::Errors::Unauthorized.new)
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
