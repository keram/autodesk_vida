require 'faraday'

require_relative 'request'
require_relative 'response'

module AutodeskVida
  class FaradayRequest < Request
    USER_AGENT = USER_AGENT
                 .dup.concat([
                   SEMICOLON, SPACE, Faraday.name, SLASH, Faraday::VERSION
                 ].join).freeze

    def self.https(uri)
      Faraday.new(uri)
    end

    def self.http(uri)
      Faraday.new(uri)
    end

    def self.connection(uri)
      send(uri.scheme, uri)
    end

    def self.status_code(response)
      response.status
    end

    def self.content_type(response)
      response['Content-Type'.freeze]
    end

    def self.response_body(response)
      response.body
    end

    def post(data)
      default_headers

      # connection.response(:logger)

      process(
        connection
          .post(uri.request_uri, data))
    end

    def put(data)
      default_headers

      process(
        connection
          .put(uri.request_uri, data))
    end

    def put_file(file)
      default_headers

      connection.builder.handlers.clear
      connection.adapter(Faraday.default_adapter)

      process(connection.put(uri.request_uri, file))
    end

    def post_json(data)
      headers('Content-Type'.freeze => JSON_CONTENT_TYPE)
      post(data.to_json)
    end

    def get
      default_headers

      # connection.response(:logger)

      process(
        connection
          .get(uri.request_uri))
    end

    def default_headers
      headers(
        'User-Agent' => USER_AGENT,
        'Accept' => JSON_CONTENT_TYPE
      )
    end

    def headers(headers)
      connection.headers.merge!(headers)
      connection
    end
  end
end
