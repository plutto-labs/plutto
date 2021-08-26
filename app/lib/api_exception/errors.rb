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
            docs_url: 'https://getplutto.com/docs#')
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
        docs_url: 'https://getplutto.com/docs#')
    end
  end

  class Forbidden < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'authentication_error',
        http_code: '403',
        code: 'unauthorized',
        message: "The API key doesn't have permissions to perform the request.",
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://getplutto.com/docs#')
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
        docs_url: 'https://getplutto.com/docs#')
    end
  end

  class Conflict < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'invalid_request_error',
        http_code: '409',
        code: 'conflict_error',
        message: 'The request conflicts with another request (perhaps due to using the same' \
          'idempotent key).',
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://getplutto.com/docs#')
    end
  end

  class TooManyRequests < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'invalid_request_error',
        http_code: '429',
        code: 'too_many_requests',
        message: 'Too many requests hit the API too quickly. Consider throttling them' \
          'in your client',
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://getplutto.com/docs#')
    end
  end

  class InternalServerError < ApiException::BaseException
    def initialize(**kwargs)
      super(type: 'api_error',
        http_code: '500',
        code: 'internal_server_error',
        message: "Something went wrong by our side. We're probably already looking into it.",
        detail: kwargs[:detail],
        param: kwargs[:param],
        request_id: kwargs[:request_id],
        docs_url: 'https://getplutto.com/docs#')
    end
  end
end
