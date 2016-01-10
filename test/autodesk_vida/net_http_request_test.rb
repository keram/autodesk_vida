require_relative '../test_helper'

require 'autodesk_vida/request'

module AutodeskVida
  describe 'NetHttpRequest' do
    let(:uri) { URI('http://test') }
    let(:http_client) { NetHttpRequest.new(uri) }
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
        'User-Agent' => NetHttpRequest::USER_AGENT
      }
    end

    describe '::USER_AGENT' do
      it 'includes Net::HTTP http client name' do
        assert_includes NetHttpRequest::USER_AGENT, Net::HTTP.name
      end
    end

    describe '.post' do
      it 'respond to post' do
        assert http_client.respond_to?(:post)
      end
    end

    describe '.http' do
      it 'returns instance of Net::HTTP' do
        assert NetHttpRequest.http(uri.host, uri.port).is_a? Net::HTTP
      end
    end

    describe '.https' do
      it 'returns instance of Net::HTTP' do
        assert NetHttpRequest.https(uri.host, uri.port).is_a? Net::HTTP
      end
    end

    describe '.post' do
      it 'returns instance of Net::HTTP::Post' do
        assert NetHttpRequest.post(uri).is_a? Net::HTTP::Post
      end
    end

    describe '.get' do
      it 'returns instance of Net::HTTP::Get' do
        assert NetHttpRequest.get(uri).is_a? Net::HTTP::Get
      end
    end

    describe '.put' do
      it 'returns instance of Net::HTTP::Put' do
        assert NetHttpRequest.put(uri).is_a? Net::HTTP::Put
      end
    end

    describe '.form_data' do
      it 'returns instance of Net::HTTP::Post' do
        request = NetHttpRequest.post(uri)
        request = NetHttpRequest.form_data(request, a: :b)

        assert request.is_a? Net::HTTP::Post
      end

      it 'includes data to the request body' do
        request = NetHttpRequest.post(uri)
        request = NetHttpRequest.form_data(request, a: :b)

        assert_equal request.body, 'a=b'
      end
    end

    describe '.connection' do
      it 'returns instance of Net::HTTP' do
        assert NetHttpRequest.connection(uri).is_a? Net::HTTP
      end
    end

    describe '.status_code' do
      it 'returns response code as number' do
        stub_request(:get, 'http://test/')
          .to_return(status: 200)

        request = NetHttpRequest.get(uri)
        connection = NetHttpRequest.http(uri.host, uri.port)
        response = connection.request(request)
        assert_equal NetHttpRequest.status_code(response), 200
      end
    end

    describe '.default_headers' do
      it 'sets user agent default on request' do
        request = NetHttpRequest.default_headers(NetHttpRequest.get(uri))
        assert_equal request['User-Agent'], NetHttpRequest::USER_AGENT
      end

      it 'sets json accept content type on request' do
        request = NetHttpRequest.default_headers(NetHttpRequest.get(uri))
        assert_equal request['Accept'], NetHttpRequest::JSON_CONTENT_TYPE
      end

      it 'returns request' do
        request = NetHttpRequest.get(uri)
        assert_equal NetHttpRequest.default_headers(request), request
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
