require 'hurley'

require_relative 'request.rb'
require_relative 'response.rb'

module AutodeskVida
  class HurleyRequest < Request
    USER_AGENT = USER_AGENT
                 .dup.concat([
                   SEMICOLON, SPACE, Hurley.name, SLASH, Hurley::VERSION
                 ].join).freeze

    def self.https(uri)
      Hurley::Client.new(uri)
    end

    def self.http(uri)
      Hurley::Client.new(uri)
    end

    def self.connection(uri)
      send(uri.scheme, uri)
    end

    def self.status_code(response)
      response.status_code
    end

    def self.content_type(response)
      response.header['Content-Type'.freeze]
    end

    def self.response_body(response)
      response.body
    end

    def initialize(uri)
      @headers = {}
      super(uri)
    end

    def post(data)
      default_headers
      custom_headers

      process(connection.post(uri.request_uri, data))
    end

    def post_json(data)
      headers('Content-Type'.freeze => JSON_CONTENT_TYPE)
      post(data.to_json)
    end

    def get
      default_headers
      custom_headers

      process(connection.get(uri.request_uri))
    end

    def put(data)
      default_headers
      custom_headers

      process(
        connection
          .put(uri.request_uri, data))
    end

    def put_file(file_path)
      put(File.read(file_path))
    end

    def headers(headers)
      @headers.merge!(headers)
    end

    def default_headers
      connection.header.update('User-Agent' => USER_AGENT,
                               'Accept' => JSON_CONTENT_TYPE)
    end

    def custom_headers
      connection.header.update(@headers)
    end
  end
end
