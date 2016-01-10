require 'autodesk_vida/version'
require 'autodesk_vida/errors'

module AutodeskVida
  autoload :Authentication, 'autodesk_vida/authentication'
  autoload :Client, 'autodesk_vida/client'
  autoload :NetHttpRequest, 'autodesk_vida/net_http_request'
  autoload :FaradayRequest, 'autodesk_vida/faraday_request'
  autoload :HurleyRequest, 'autodesk_vida/hurley_request'
  autoload :Endpoint, 'autodesk_vida/endpoint'

  EMPTY = ''.freeze
  SLASH = '/'.freeze
  SPACE = ' '.freeze
  SEMICOLON = ';'.freeze

  def self.http_client=(http_client)
    @http_client = http_client
  end

  def self.http_client
    @http_client
  end

  self.http_client = HurleyRequest
  # self.http_client = NetHttpRequest
  # self.http_client = FaradayRequest
end
