require_relative 'base'
require_relative 'request'
require_relative 'access_token'

module AutodeskVida
  class Authentication < Base
    def initialize(client_id:, client_secret:, grant_type:)
      @credentials = {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: grant_type
      }
    end

    # Error responses
    #
    # {"developerMessage":"content-type header missing or unsupported
    #   content-type used, must use application/x-www-form-urlencoded",
    #   "userMessage":"","errorCode":"AUTH-007",
    #   "more info":
    #   "http://developer.api.autodesk.com/documentation/v1/errors/AUTH-007"}
    # {"developerMessage":"The required parameter(s) client_id,
    #   client_secret,grant_type not present in the request","userMessage":"",
    #   "errorCode":"AUTH-008",
    #   "more info":
    #   "http://developer.api.autodesk.com/documentation/v1/errors/AUTH-008"}
    # {"developerMessage":"Unsupported grant_type 4 specified.
    #   The grant_type must be either client_credentials or authorization_code
    #   or refresh_token.","userMessage":"","errorCode":"AUTH-009",
    #   "more info":
    #   "http://developer.api.autodesk.com/documentation/v1/errors/AUTH-009"}
    # { "developerMessage":"The client_id specified does not have access
    #   to the api product","userMessage":"", "errorCode":"AUTH-001",
    #   "more info":
    #   "http://developer.api.autodesk.com/documentation/v1/errors/AUTH-001"}
    # {"developerMessage":"The client_id (application key)/client_secret
    #   are not valid","userMessage":"","errorCode":"AUTH-003",
    #   "more info":
    #   "http://developer.api.autodesk.com/documentation/v1/errors/AUTH-003"}
    #
    # Success response
    # {
    #   "token_type":"Bearer",
    #   "expires_in":1799,
    #   "access_token":"m3avgSSFyr9fKUmo2CMsHhsT1Z8W"
    #  }
    def perform
      AccessToken.new(
        request(endpoint).post(@credentials)
      )
    end
  end
end
