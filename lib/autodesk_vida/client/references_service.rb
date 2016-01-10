module AutodeskVida
  class Client
    module ReferencesService
      def reference=(reference)
        request = request(set_reference_url)
        request.headers('Authorization'.freeze => access_token.to_s)
        request.post_json(reference)
      end
      alias_method :set_reference, :reference=

      def set_reference_url
        URI(Endpoint::SET_REFERENCE)
      end
    end
  end
end
