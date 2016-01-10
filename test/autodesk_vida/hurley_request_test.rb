require_relative '../test_helper'
require 'autodesk_vida/faraday_request'

module AutodeskVida
  describe 'HurleyRequest' do
    let(:uri) { URI('http://test') }
    let(:http_client) { HurleyRequest.new(uri) }
    let(:response) do
      { status: 200,
        body: {}.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
    end

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => HurleyRequest::USER_AGENT
      }
    end

    describe '::USER_AGENT' do
      it 'includes Hurley http client name' do
        assert_includes HurleyRequest::USER_AGENT, Hurley.name
      end
    end

    describe '.http' do
      it 'returns Hurley connection' do
        conn = HurleyRequest.http('http://test.sk')

        assert conn.is_a? Hurley::Client
      end
    end

    describe '.https' do
      it 'returns Hurley connection' do
        conn = HurleyRequest.https('https://test.sk')

        assert conn.is_a? Hurley::Client
      end
    end

    describe '.connection' do
      it 'returns Hurley connection' do
        assert HurleyRequest.connection(uri).is_a? Hurley::Client
      end
    end

    describe '.status_code' do
      it 'returns response code as number' do
        stub_request(:get, 'http://test/').to_return(status: 202)

        response = HurleyRequest.http(uri).get(nil)

        assert_equal HurleyRequest.status_code(response), 202
      end
    end

    describe '#post' do
      it 'returns Hash' do
        stub_request(:post, 'http://test/')
          .with(headers: headers).to_return(response)

        assert http_client.post(x: :y).is_a? Hash
      end
    end

    describe '#post_json' do
      it 'returns Hash' do
        stub_request(:post, 'http://test/')
          .with(headers: headers).to_return(response)

        assert http_client.post_json(x: 123).is_a? Hash
      end
    end

    describe '#put' do
      it 'returns Hash' do
        stub_request(:put, 'http://test/')
          .with(headers: headers).to_return(response)

        assert http_client.put(x: 123).is_a? Hash
      end
    end

    describe '#get' do
      it 'returns Hash' do
        stub_request(:get, 'http://test/')
          .with(headers: headers).to_return(response)

        assert http_client.get.is_a? Hash
      end
    end
  end
end
