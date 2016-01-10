module AutodeskVida
  module Endpoint
    BASE = 'https://developer.api.autodesk.com'.freeze
    AUTHENTICATION = "#{BASE}/authentication/v1/authenticate".freeze
    BUCKETS = "#{BASE}/oss/v2/buckets".freeze
    SUPPORTED_FORMATS = "#{BASE}/viewingservice/v1/supported".freeze
    SET_REFERENCE = "#{BASE}/references/v1/setreference".freeze
    VIEWING_SERVICE = "#{BASE}/viewingservice/v1".freeze
    REGISTER = "#{VIEWING_SERVICE}/register".freeze
    THUMBNAILS = "#{VIEWING_SERVICE}/thumbnails".freeze
  end
end
