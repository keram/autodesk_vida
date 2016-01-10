module AutodeskVida
  class Error < ::StandardError; end
  class ConfigurationError < Error; end

  class ClientError < Error
    def initialize(message)
      super(message.fetch('message'))
    rescue NoMethodError, KeyError
      super
    end
  end

  class BadRequestError < ClientError
    def initialize(message)
      super(message.fetch('reason'))
    rescue NoMethodError, KeyError
      super
    end
  end

  class AuthenticationFailureError < ClientError; end
  class NotAuthenticatedError < ClientError; end
  class UnknownError < ClientError; end
  class UnauthorizedError < ClientError; end
  class ForbiddenError < ClientError; end
  class NotFoundError < ClientError; end
  class ConflictError < ClientError; end
  class UnsupportedMediaTypeError < ClientError; end
  class InternalServerError < ClientError; end
  class ServiceUnavailableError < ClientError; end
end
