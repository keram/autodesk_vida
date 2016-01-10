module AutodeskVida
  class Client
    module FilesService
      def supported_formats
        request = request(supported_formats_url)
        request.headers('Authorization'.freeze => access_token.to_s)
        request.get
      end

      def supported_formats_url
        URI(Endpoint::SUPPORTED_FORMATS)
      end

      def upload_file(bucket, file_path)
        request = request(upload_file_url(bucket,
                                          File.basename(file_path)))
        request.headers('Content-Length'.freeze => File.size(file_path).to_s)
        request.headers('Authorization'.freeze => access_token.to_s)

        request.put_file(file_path)
      end

      def upload_file_url(bucket, file_name)
        URI("#{Endpoint::BUCKETS}/#{bucket}/objects/#{file_name}")
      end
    end
  end
end
