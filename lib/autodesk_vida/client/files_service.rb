module AutodeskVida
  class Client
    module FilesService
      def supported_formats
        request = request(supported_formats_url)
        request.headers(auth_header)
        request.get
      end

      def supported_formats_url
        URI(Endpoint::SUPPORTED_FORMATS)
      end

      def upload_file(bucket, file)
        request = request(upload_file_url(bucket,
                                          File.basename(file.path)))
        request.headers('Content-Length'.freeze => file.size.to_s)
        request.headers(auth_header)

        request.put_file(file)
      end

      def upload_file_url(bucket, file_name)
        URI("#{Endpoint::BUCKETS}/#{bucket}/objects/#{file_name}")
      end
    end
  end
end
