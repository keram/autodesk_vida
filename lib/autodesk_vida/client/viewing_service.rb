require 'base64'

module AutodeskVida
  class Client
    module ViewingService
      URN_KEY = 'urn'.freeze

      def register(params)
        register_with_headers(params: params, headers: {})
      end

      def register_with_headers(params:, headers:)
        request = request(register_url)
        request.headers(
          headers.merge(auth_header)
        )

        request.post_json(params)
      end

      def register_url
        URI(Endpoint::REGISTER)
      end

      def status(params)
        request = request(status_url(params.fetch(URN_KEY)))
        request.headers(auth_header)

        request.get
      end

      def status_url(urn)
        URI("#{Endpoint::VIEWING_SERVICE}/#{urn}")
      end

      # Parameters:
      #
      # urn - Required. The url encoded URN of the item.
      # It only accepts the URN of viewing service
      # ( urn:adsk.viewing:fs.file:url-safe-base64-urn/rest/of/the/path)
      #  The URN could be retrieved from GET viewable API by specifying
      #  header: x-ads-transform-resource-urn = static-url
      #
      # Query Parameters:
      #
      #  guid - Optional. The id (guid) of a subset of viewables.
      #  width - Optional. The width of the requested thumbnail.
      #  height - Optional. The height of the requested thumbnail.
      #  type - Optional. The type of the requested thumbnail,
      #  one of 'small', 'medium' or 'large'.
      #  The width or height url-query parameters
      #  will be shadowed by giving the type.
      #
      def thumbnail(params)
        request = request(
          thumbnail_url(params.fetch(URN_KEY),
                        params.reject { |key| key == URN_KEY }))
        request.headers(auth_header)

        request.get
      end

      def thumbnail_url(urn, query_params)
        query_params = [
          urn,
          URI.encode_www_form(query_params)
        ].compact.reject(&:empty?).join('?')

        URI("#{Endpoint::THUMBNAILS}/#{query_params}")
      end
    end
  end
end
