module ApiException::Errors
  class BadRequest < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'invalid_request_error',
            http_code: '400',
            code: 'bad_request',
            message: 'The request was unacceptable, often due to missing a required parameter.',
            detail: kwargs[:detail],
            param: kwargs[:param],
            request_id: kwargs[:request_id],
            docs_url: 'https://plutto.readme.io')
    end
  end

  class UnprocessableEntity < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'invalid_request_error', # :nocov:
            http_code: '422',
            code: 'unprocessable_entity',
            message: 'Your request was understood, but we were not able to process it. Please ' \
             'fix it before repeating',
            detail: kwargs[:detail],
            param: kwargs[:param],
            request_id: kwargs[:request_id],
            docs_url: 'https://plutto.readme.io')
    end
  end

  class Unauthorized < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'authentication_error',
        http_code: '401',
        code: 'unauthorized',
        message: 'No valid API key provided.',
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://plutto.readme.io')
    end
  end

  class NotFound < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'invalid_request_error',
        http_code: '404',
        code: 'resource_not_found',
        message: 'The requested resource cannot be found. This item does not exist or has been ' \
          'previously removed.',
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://plutto.readme.io')
    end
  end

  class InternalServerError < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'api_error', # :nocov:
        http_code: '500',
        code: 'internal_server_error',
        message: "Something went wrong by our side. We're probably already looking into it.",
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://plutto.readme.io')
    end
  end
end
