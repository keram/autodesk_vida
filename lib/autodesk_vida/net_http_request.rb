require 'net/http'
require 'openssl'

require_relative 'request'
require_relative 'response'

module AutodeskVida
  class NetHttpRequest < Request
    USER_AGENT = USER_AGENT
                 .dup.concat([
                   SEMICOLON, SPACE, Net::HTTP.name
                 ].join).freeze

    def self.https(hostname, port)
      http(hostname, port).tap do |http|
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end

    def self.http(hostname, port)
      Net::HTTP.new(hostname, port)
    end

    def self.post(uri)
      Net::HTTP::Post.new(uri.request_uri)
    end

    def self.get(uri)
      Net::HTTP::Get.new(uri.request_uri)
    end

    def self.put(uri)
      Net::HTTP::Put.new(uri.request_uri)
    end

    def self.form_data(request, data)
      request.set_form_data(data)
      request
    end

    def self.connection(uri)
      send(uri.scheme, uri.hostname, uri.port)
    end

    def self.status_code(response)
      response.code.to_i
    end

    def self.content_type(response)
      response.content_type
    end

    def self.default_headers(request)
      request['User-Agent'] = USER_AGENT
      request['Accept'] = JSON_CONTENT_TYPE
      request
    end

    def self.json_request_default_headers(request)
      default_headers(request)
      request['Content-Type'.freeze] = JSON_CONTENT_TYPE
      request
    end

    def initialize(uri)
      @headers = {}
      super(uri)
    end

    def post(data)
      request = klass.post(uri)
      klass.form_data(request, data)

      default_headers(request)
      custom_headers(request)

      process(execute(request))
    end

    def post_json(data)
      request = klass.post(uri)
      request.body = data.to_json

      json_request_default_headers(request)
      custom_headers(request)

      process(execute(request))
    end

    def get
      request = klass.get(uri)

      default_headers(request)
      custom_headers(request)

      process(execute(request))
    end

    def put(data)
      request = klass.put(uri)
      klass.form_data(request, data)

      default_headers(request)
      custom_headers(request)

      process(execute(request))
    end

    def put_file(file_path)
      request = klass.put(uri)

      default_headers(request)
      custom_headers(request)

      request.body = File.read(file_path)

      process(execute(request))
    end

    def headers(headers)
      @headers.merge!(headers)
    end

    private

    def execute(request)
      connection.request(request)
    end

    def default_headers(request)
      klass.default_headers(request)
    end

    def json_request_default_headers(request)
      klass.json_request_default_headers(request)
    end

    def custom_headers(request)
      @headers.each { |header, value| request[header] = value }
      request
    end
  end
end
