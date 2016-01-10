require_relative '../../test_helper'

module AutodeskVida
  [HurleyRequest, NetHttpRequest, FaradayRequest].each do |http_client_class|
    describe "#{http_client_class.name} ClientBucketsService" do
      before { AutodeskVida.http_client = http_client_class }

      let(:client) { Client.new('Bearer y') }
      let(:sample_bucket_attributes) do
        {
          'bucketKey' => 'mybucketx',
          'bucketOwner' => 'HanexjfJMGC9GnveB5NNqbjzF3bvQlAH',
          'createDate' => 1_440_355_171_547,
          'permissions' => [{
            'serviceId' => 'HanexjfJMGC9GnveB5NNqbjzF3bvQlAH',
            'access' => 'full'
          }],
          'policyKey' => 'transient'
        }
      end

      describe '#create_bucket' do
        let(:success_response) do
          {
            status: 200,
            body: sample_bucket_attributes.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it 'will return bucket as Hash' do
          stub_request(:post, Endpoint::BUCKETS)
            .to_return(success_response)

          bucket = client.create_bucket(retention_policy: :transient,
                                        bucket_key: 'mybucketx')
          assert bucket.is_a? Hash
        end

        describe 'bucket already exist' do
          let(:fail_response) do
            {
              status: 409,
              body: '{"reason":"Bucket already exist"}',
              headers: { 'Content-Type' => 'application/json' }
            }
          end

          it 'will throw conflict error' do
            stub_request(:post, Endpoint::BUCKETS)
              .to_return(fail_response)

            proc do
              client.create_bucket(retention_policy: :transient,
                                   bucket_key: 'mybucketx')
            end.must_raise ConflictError
          end
        end
      end

      describe '#bucket' do
        let(:bucket_key) { 'testmla' }
        let(:success_response) do
          {
            status: 200,
            body: sample_bucket_attributes.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        let(:not_found_response) do
          {
            status: 404,
            body: {
              'reason' => 'Bucket not found'
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        let(:no_right_to_access_response) do
          {
            status: 403,
            body: ''
          }
        end

        let(:request_headers) do
          {
            'Accept' => 'application/json',
            'Authorization'.freeze => 'Bearer y',
            'User-Agent' => AutodeskVida.http_client::USER_AGENT
          }
        end

        it 'requires bucket key' do
          proc { client.bucket }.must_raise ArgumentError
        end

        it 'returns bucket as Hash' do
          stub_request(:get, "#{Endpoint::BUCKETS}/#{bucket_key}/details")
            .with(headers: request_headers).to_return(success_response)

          bucket = client.bucket bucket_key
          assert bucket.is_a? Hash
        end

        # describe 'bucket does not exist yet' do
        #   it 'raise ClientError' do
        #     stub_request(:get, "#{Endpoint::BUCKETS}/#{bucket_key}/details")
        #       .with(headers: request_headers)
        #       .to_return(not_found_response)

        #     proc { client.bucket bucket_key }.must_raise ClientError
        #   end
        # end

        # describe 'not authorized access bucket' do
        #   it 'raise ClientError' do
        #     stub_request(:get, "#{Endpoint::BUCKETS}/#{bucket_key}/details")
        #       .with(headers: request_headers)
        #       .to_return(no_right_to_access_response)

        #     proc { client.bucket bucket_key }.must_raise ClientError
        #   end
        # end
      end
    end
  end
end
