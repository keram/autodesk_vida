require_relative 'authentication.rb'

module AutodeskVida
  class Client
    require_relative 'client/buckets_service'
    require_relative 'client/files_service'
    require_relative 'client/references_service'
    require_relative 'client/viewing_service'

    include BucketsService
    include FilesService
    include ReferencesService
    include ViewingService

    def self.request(uri)
      Module.nesting.last.http_client.new(uri)
    end

    attr_reader :auth_header

    def initialize(access_token)
      @auth_header = { 'Authorization'.freeze => access_token.to_s }
    end

    private

    def request(uri)
      self.class.request(uri)
    end
  end
end
