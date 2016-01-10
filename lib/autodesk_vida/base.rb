require_relative 'endpoint'

module AutodeskVida
  class Base
    def self.endpoint
      URI(Endpoint.const_get name.split('::').last.upcase)
    end

    def self.request(uri)
      Module.nesting.last.http_client.new(uri)
    end

    def endpoint
      self.class.endpoint
    end

    def request(uri)
      self.class.request uri
    end
  end
end
