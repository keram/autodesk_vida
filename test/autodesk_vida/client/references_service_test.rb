require_relative '../../test_helper'

module AutodeskVida
  [HurleyRequest, NetHttpRequest, FaradayRequest].each do |http_client_class|
    describe "#{http_client_class.name} ClientReferencesService" do
      before { AutodeskVida.http_client = http_client_class }

      let(:access_token) { 'Bearer y' }
      let(:client) { Client.new(access_token) }
      let(:request_headers) do
        {
          'Accept' => 'application/json',
          'Authorization'.freeze => access_token,
          'User-Agent' => AutodeskVida.http_client::USER_AGENT
        }
      end

      describe '#set_reference' do
        let(:success_response) do
          {
            status: 200,
            headers: {
              'Content-type' => 'application/json'
            },
            body: {}.to_json
          }
        end

        let(:master_file) do
          {
            'bucketKey' => 'testmla',
            'objectId' => 'urn:adsk.objects:os.object:testmla/Locker.3DS',
            'objectKey' => 'Locker.3DS',
            'sha1' => '7ee3cc022822961513b3b64a6cf3f78fb34cbf5d',
            'size' => 44, 'contentType' => 'application/x-www-form-urlencoded',
            'location' => 'https://developer.api.autodesk.com/oss/v2/buckets/testmla/objects/Locker.3DS'
          }
        end

        let(:child_file) do
          {
            'bucketKey' => 'testmla',
            'objectId' => 'urn:adsk.objects:os.object:testmla/Mirror.3DS',
            'objectKey' => 'Mirror.3DS',
            'sha1' => '7ee3cc022822961513b3b64a6cf3f78fb34cbf5d',
            'size' => 44, 'contentType' => 'application/x-www-form-urlencoded',
            'location' => 'https://developer.api.autodesk.com/oss/v2/buckets/testmla/objects/Mirror.3DS'
          }
        end

        let(:reference) do
          {
            'master' => master_file['objectId'],
            'dependencies' => [{
              'file' => child_file['objectId'],
              'metadata' => {
                'childPath' => child_file['objectKey'],
                'parentPath' => master_file['objectKey']
              }
            }]
          }
        end

        it 'requires reference object' do
          proc { client.set_reference }.must_raise ArgumentError
        end

        it 'returns empty hash' do
          stub_request(:post, Endpoint::SET_REFERENCE)
            .with(headers: request_headers)
            .to_return(success_response)

          assert_equal client.set_reference(reference), {}
        end
      end
    end
  end
end
