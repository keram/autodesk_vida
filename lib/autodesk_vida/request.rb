module AutodeskVida
  class Request
    attr_reader :uri, :connection

    JSON_CONTENT_TYPE = 'application/json'.freeze
    USER_AGENT = [
      [RUBY_ENGINE, RUBY_VERSION],
      [Module.nesting.last, VERSION]
    ].map { |pair| pair.join(SLASH) }.join([SEMICOLON, SPACE].join).freeze

    def self.response_body(response)
      response.body
    end

    def initialize(uri)
      @uri = uri
      @connection = klass.connection(uri)
    end

    def process(response)
      Response.respond(
        klass.response_body(response),
        klass.content_type(response),
        klass.status_code(response))
    end

    def klass
      self.class
    end
  end
end
