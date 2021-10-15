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

    rescue_from 'Pundit::NotAuthorizedError' do |exception|
      respond_with_unauthorized({ detail: exception.message })
    end

    rescue_from 'ActiveRecord::RecordInvalid' do |exception|
      respond_api_error(
        ApiException::Errors::UnprocessableEntity.new(
          detail: exception.record.errors.full_messages.join(', '),
          param: exception.record.errors.errors[0].attribute
        )
      )
    end

    rescue_from 'ActionDispatch::Http::Parameters::ParseError' do |exception|
      respond_api_error(
        ApiException::Errors::BadRequest.new(
          detail: exception.to_s.partition(': ').last
        )
      )
    end

    rescue_from 'ApiException::BaseException' do |exception|
      respond_api_error(exception)
    end

    rescue_from 'AASM::InvalidTransition' do |exception|
      respond_api_error(ApiException::Errors::BadRequest.new(detail: exception.to_s))
    end
  end

  def respond_with_unauthorized(**kwargs)
    respond_api_error(ApiException::Errors::Unauthorized.new(kwargs))
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
