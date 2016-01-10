require 'base64'
require_relative '../../test_helper'

module AutodeskVida
  [HurleyRequest, NetHttpRequest, FaradayRequest].each do |http_client_class|
    describe "#{http_client_class.name} ClientViewingService" do
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

      let(:file) do
        {
          'bucketKey' => 'testmla',
          'objectId' => 'urn:adsk.objects:os.object:testmla/Locker.3DS',
          'objectKey' => 'Locker.3DS',
          'sha1' => '7ee3cc022822961513b3b64a6cf3f78fb34cbf5d',
          'size' => 44, 'contentType' => 'application/x-www-form-urlencoded',
          'location' => 'https://developer.api.autodesk.com/oss/v2/buckets/testmla/objects/Locker.3DS'
        }
      end

      describe '#register' do
        let(:success_response) do
          {
            status: 200,
            body: { 'Result' => 'Success' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it 'requires file object' do
          proc { client.register }.must_raise ArgumentError
        end

        it 'returns result of registration' do
          request_options =
            { urn: Base64.urlsafe_encode64(file['objectId']) }

          stub_request(:post, Endpoint::REGISTER)
            .with(body: request_options, headers: request_headers)
            .to_return(success_response)

          assert_equal client.register(request_options), 'Result' => 'Success'
        end
      end

      describe '#register_with_headers' do
        let(:success_response) do
          {
            status: 200,
            body: { 'Result' => 'Success' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it 'requires params and headers arguments' do
          proc { client.register_with_headers }.must_raise ArgumentError
          proc do
            client.register_with_headers(params: '')
          end.must_raise ArgumentError
        end

        it 'returns result of registration' do
          request_options = {
            params: { urn: Base64.urlsafe_encode64(file['objectId']) },
            headers: { 'Content-Type' => 'application/json' }
          }

          stub_request(:post, Endpoint::REGISTER)
            .with(body: request_options[:params], headers: request_headers)
            .to_return(success_response)

          response = client.register_with_headers(request_options)
          assert_equal response, 'Result' => 'Success'
        end

        it 'includes custom headers in request' do
          request_options = {
            params: { urn: Base64.urlsafe_encode64(file['objectId']) },
            headers: {
              'x-ads-force' => 'true',
              'x-ads-test' => 'false'
            }
          }

          stub_request(:post, Endpoint::REGISTER)
            .with(body: request_options[:params],
                  headers: request_headers.merge('x-ads-test' => 'false'))
            .to_return(success_response)

          response = client.register_with_headers(request_options)
          assert_equal response, 'Result' => 'Success'
        end

        describe 'x-ads-test header' do
          let(:response_body) do
            {
              'url' => '/data/v1/',
              'headers' => {
                'x-ads-verbatim' => 'false',
                'x-ads-alias' => 'dXJuOmFkc2sub2JqZWN9Mb2NrZXIuM0RT',
                'X-B3-TraceId' => '5639c4ace772dace772d337',
                'x-ads-family' => 'assimp-viewing-extraction'
              },
              'form' => {
                'data-script' => 'viewing-assimp',
                'data-parameters' => {
                  'seed' => 'dXJuOmFkc2sub2JqZsYS9Mb2NrZXIuM0RT',
                  'guid' => 'aa85aad6-c480-4a35-9cbf-4cf5994a25ba',
                  'derivative_type' => {
                    'thumbnail' => { 'role' => 'rendered' },
                    '2dviewing' => {},
                    '3dviewing' => {}
                  },
                  'client' => 'q9ZkEG3OJHOGNwosAsh7xxT1AyKbPR19',
                  'token' => '',
                  'from' => 'urn:adsk.objects:os.object:testmla/Locker.3DS',
                  'delete_existing_artifacts' => 'false',
                  'callback_bubble' => 'https://viewing.api.autodesk.com/viewingservice/v1/bubbles',
                  'traceid' => '5639c4ace772dd337<:5639c4ace772d337',
                  'user' => 'q9ZkEG3OJHOGNwosAsh7xxT1AyKbPR19'
                }.to_json
              }
            }
          end

          it 'returns all parameters for translation.' do
            request_options = {
              params: { urn: Base64.urlsafe_encode64(file['objectId']) },
              headers: {
                'x-ads-test' => 'true'
              }
            }

            stub_request(:post, Endpoint::REGISTER)
              .with(body: request_options[:params],
                    headers: request_options[:headers])
              .to_return(success_response.merge(body: response_body.to_json))

            response = client.register_with_headers(request_options)
            assert_equal response_body, response
          end
        end
      end

      describe '#status' do
        let(:response_body) do
          {
            'version': '1.0',
            'urn': 'dXJuOmFkc2suczM6pY2UvYXBpL3NhbXBsZS5kd2Y=',
            'guid': 'dXJuOmFkc2suczM6pY2UvYXBpL3NhbXBsZS5kd2Y=',
            'name': 'sample.dwf',
            'type': 'design',
            'progress': '30%',
            'status': 'Pending',
            'hasThumbnail': 'true',
            'messages': [
              {
                'type': 'warning',
                'code': '123',
                'message': 'this is a 123 warning'
              },
              {
                'type': 'error',
                'code': '234',
                'message': 'this is a 234 error'
              },
              {
                'type': 'info',
                'code': '334',
                'message': 'this is a 334 info'
              }
            ],
            'children': [
              {
                'guid': '067e6162-3b6f-4ae2-a171-2470b63dff02',
                'type': 'folder',
                'hasThumbnail': 'false',
                'name': 'DWG generation',
                'role': 'conversion',
                'status': 'on-demand'
              },
              {
                'guid': '067e6162-3b6f-4ae2-a171-2470b63dfe02',
                'type': 'folder',
                'hasThumbnail': 'false',
                'name': 'IVT conversion',
                'progress': 'Complete',
                'role': 'conversion',
                'status': 'Success',
                'children': [
                  {
                    'guid': '067e6162-3b6f-4ae2-a171-2470b63dff44',
                    'type': 'resource',
                    'messages': [{
                      'type': 'warning',
                      'code': '666',
                      'message': 'model structure could not be preserved'
                    }],
                    'mime': 'application/autodesk-ivt',
                    'size': 222,
                    'urn': 'urn:adsk.viewing:fs.file:dXJuOm=/output/1/0_dwf.ivt'
                  }
                ]
              },
              {
                'guid': '067e6162-3b6f-4ae2-a171-2470b63dff77',
                'type': 'resource',
                'mime': 'application/autodesk-db',
                'name': 'property db',
                'progress': 'Complete',
                'role': 'Autodesk.CloudPlatform.PropertyDatabase',
                'status': 'Success',
                'urn': 'urn:adsk.viewing:fs.file:dXJuO/1/section_properties.db'
              }
            ]
          }
        end

        let(:success_response) do
          {
            status: 200,
            body: response_body.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it 'returns json' do
          request_options =
            { 'urn' => Base64.urlsafe_encode64(file['objectId']) }

          stub_request(:get, "https://developer.api.autodesk.com/viewingservice/v1/#{request_options['urn']}")
            .to_return(success_response)

          response = client.status(request_options)
          assert_equal JSON.parse(response_body.to_json), response
        end
      end

      describe '#thumbnail' do
        let(:thumbnail_file_path) do
          File.join(
            File.dirname(__FILE__),
            '..', '..', 'fixtures', 'mirror_thumbnail.png')
        end

        let(:success_response) do
          {
            status: 200,
            body: File.read(thumbnail_file_path),
            headers: {
              'Content-Type' => 'image/png'
            }
          }
        end

        it 'returns image' do
          request_options =
            { 'urn' => Base64.urlsafe_encode64(file['objectId']) }

          stub_request(:get, "https://developer.api.autodesk.com/viewingservice/v1/thumbnails/#{request_options['urn']}")
            .to_return(success_response)

          response = client.thumbnail(request_options)

          assert_equal File.read(thumbnail_file_path), response
        end
      end
    end
  end
end
