module AutodeskVida
  class Client
    module BucketsService
      # {"key"=>"mybucketx", "owner"=>"HanexjfJMGC9GnveB5NNqbjzF3bvQlAH",
      # "createDate"=>1440355171547, "permissions"=>[
      #   {"serviceId"=>"HanexjfJMGC9GnveB5NNqbjzF3bvQlAH", "access"=>"full"}],
      # "policyKey"=>"transient"}
      def create_bucket(retention_policy:, bucket_key:)
        request = request(create_bucket_url)
        request.headers('Authorization'.freeze => access_token.to_s)
        request.post_json(policyKey: retention_policy,
                          bucketKey: bucket_key)
      end

      def bucket(key)
        request = request(bucket_details_url(key))
        request.headers('Authorization'.freeze => access_token.to_s)
        request.get
      end

      private

      def create_bucket_url
        URI(Endpoint::BUCKETS)
      end

      def bucket_details_url(key)
        URI("#{Endpoint::BUCKETS}/#{key}/details")
      end
    end
  end
end
