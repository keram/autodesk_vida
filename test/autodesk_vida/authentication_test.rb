require_relative '../test_helper'
require 'autodesk_vida/authentication'

module AutodeskVida
  [HurleyRequest, NetHttpRequest, FaradayRequest].each do |http_client_class|
    describe "#{http_client_class.name} Authentication" do
      before { AutodeskVida.http_client = http_client_class }

      let(:credentials) do
        {
          client_id: 'q9ZkEG3OJHOGNwosAsh7xxT1AyKbPR19',
          client_secret: 'RFXa2dZ7i6VCX0GE',
          grant_type: 'client_credentials'
        }
      end

      describe '#initialize' do
        it 'require credentials' do
          proc { Authentication.new }.must_raise ArgumentError

          Authentication.new(credentials)
            .must_be_instance_of AutodeskVida::Authentication
        end

        it 'sets credentials' do
          assert_equal Authentication.new(credentials)
            .instance_variable_get('@credentials'),
                       credentials
        end
      end

      describe '#perform' do
        let(:authentication) { AutodeskVida::Authentication.new(credentials) }
        let(:success_response) do
          {
            status: 200,
            body: '{"token_type":"Bearer","expires_in":1799,"access_token":"y"}',
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        let(:fail_response) do
          {
            status: 403,
            body: {
              'developerMessage' =>
                'The client_id (application key)/client_secret are not valid',
              'userMessage' => '',
              'errorCode' => 'AUTH-003',
              'more info' => 'http://developer.api.autodesk.com/documentation/v1/errors/AUTH-003'
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        describe 'correct credentials' do
          it 'will return access token' do
            stub_request(:post, AutodeskVida::Endpoint::AUTHENTICATION)
              .to_return(success_response)

            authentication.perform.must_be_instance_of AccessToken
          end
        end

        describe 'incorrect credentials' do
          it 'will throw authentication exception' do
            stub_request(:post, AutodeskVida::Endpoint::AUTHENTICATION)
              .to_return(fail_response)

            proc { authentication.perform }.must_raise AuthenticationFailureError
          end
        end
      end
    end
  end
end
