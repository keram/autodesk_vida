require 'json'

module AutodeskVida
  module Response
    RESPONSE_CODES = {
      200 => :HTTPOK,
      201 => :HTTPCreated,
      205 => :HTTPNoContent,
      400 => :HTTPBadRequest,
      401 => :HTTPUnauthorized,
      403 => :HTTPForbidden,
      404 => :HTTPNotFound,
      409 => :HTTPConflict,
      415 => :HTTPUnsupportedMediaType,
      500 => :HTTPInternalServerError,
      504 => :HTTPGatewayTimeout
    }

    PROCESSORS_CODES = {
      'application/json; charset=utf-8' => :JSON,
      'application/json' => :JSON,
      'image/png' => :Binary
    }

    def self.respond(content, content_type, status_code)
      Handler.const_get(RESPONSE_CODES.fetch(status_code))
        .handle(processor(content_type).process(content))
    end

    def self.processor(content_type)
      Processor.const_get(PROCESSORS_CODES.fetch(content_type))
    end

    module Processor
      module JSON
        require 'json'

        def self.process(data)
          ::JSON.parse(data)
        rescue ::JSON::ParserError
          {}
        end
      end

      module Binary
        def self.process(data)
          data
        end
      end
    end

    module Handler
      module HTTPOK
        def self.handle(body)
          body
        end
      end

      module HTTPCreated
        def self.handle(body)
          body
        end
      end

      module HTTPNoContent
        def self.handle(body)
          body
        end
      end

      module HTTPBadRequest
        def self.handle(body)
          fail BadRequestError, body
        end
      end

      module HTTPUnauthorized
        def self.handle(body)
          fail UnauthorizedError, body
        end
      end

      module HTTPForbidden
        def self.handle(body)
          fail AuthenticationFailureError, body
        end
      end

      module HTTPNotFound
        def self.handle(body)
          fail NotFoundError, body
        end
      end

      module HTTPConflict
        def self.handle(body)
          fail ConflictError, body['reason']
        end
      end

      module HTTPUnsupportedMediaType
        def self.handle(body)
          fail UnsupportedMediaTypeError, body
        end
      end

      module HTTPInternalServerError
        def self.handle(body)
          fail InternalServerError, body
        end
      end

      module HTTPGatewayTimeout
        def self.handle(body)
          fail ServiceUnavailableError, body
        end
      end
    end
  end
end
