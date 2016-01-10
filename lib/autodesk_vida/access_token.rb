module AutodeskVida
  class AccessToken
    attr_reader :token_type, :expires_in, :access_token

    def initialize(options)
      @token_type = options.fetch('token_type')
      @expires_in = Time.now + options.fetch('expires_in')
      @access_token = options.fetch('access_token')
    end

    def to_s
      [token_type, access_token].join(' ').freeze
    end

    def expired?
      Time.now >= expires_in
    end
  end
end
