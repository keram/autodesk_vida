require_relative '../../test_helper'

module AutodeskVida
  [HurleyRequest, NetHttpRequest, FaradayRequest].each do |http_client_class|
    describe "#{http_client_class.name} ClientFilesService" do
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

      describe '#supported_formats' do
        let(:success_response) do
          {
            status: 200,
            body: '{"extensions":["ipt","neu","stla","stl","xlsx","jt","jpg",
            "skp", "collaboration","prt","dwf","xls","png","sldasm","step","dwg",
            "zip", "nwc","model","sim","stp","ste","f3d","pdf","iges","idw","dwt",
            "dxf", "catproduct","csv","igs","sldprt","cgr","3dm","sab","obj",
            "pptx", "cam360","jpeg","bmp","gbxml","exp","ppt","doc","wire","ige",
            "rcp", "txt","dae","x_b","3ds","rtf","rvt","g","sim360","iam","asm",
            "dlv3", "x_t","pps","session","xas","xpr","docx","catpart","stlb",
            "tiff", "nwd","sat","fbx","smb","smt","ifc","dwfx","tif"],
            "channelMapping":{
              "ipt":"viewing-inventor-lmv","neu":"viewing-atf-lmv",
              "stla":"viewing-atf-lmv","stl":"viewing-atf-lmv",
              "xlsx":"extraction-tika","jt":"viewing-atf-lmv",
              "jpg":"extraction-tika","skp":"viewing-atf-lmv",
              "smb":"viewing-atf-lmv","smt":"viewing-atf-lmv",
              "ifc":"viewing-nwd-lmv","dwfx":"viewing-dwf-lmv",
              "tif":"extraction-tika"},
              "regExp":{"prt\\.\\d+$":"viewing-atf-lmv",
                "neu\\.\\d+$":"viewing-atf-lmv","asm\\.\\d+$":"viewing-atf-lmv"},
                "formatMapping":{},"thumbnailMapping":{"dwf":"viewing-thumbnail",
                "dwg":"viewing-thumbnail","f3d":"viewing-f3d-thumbnail",
                "dwt":"viewing-thumbnail","dxf":"viewing-thumbnail",
                "cam360":"viewing-f3d-thumbnail","dwfx":"viewing-thumbnail"}}',
            headers: {
              'Content-Type' => 'application/json'
            }
          }
        end

        it 'returns hash' do
          stub_request(:get, Endpoint::SUPPORTED_FORMATS)
            .with(headers: request_headers).to_return(success_response)

          assert client.supported_formats.is_a? Hash
        end

        it 'contains array of extensions' do
          stub_request(:get, Endpoint::SUPPORTED_FORMATS)
            .with(headers: request_headers).to_return(success_response)

          assert client.supported_formats['extensions'].is_a? Array
        end
      end

      describe '#upload_file' do
        let(:bucket) { 'testmla' }
        let(:file_name) { 'Locker.3DS' }
        let(:upload_file) do
          File.new(
            File.join(
              File.dirname(__FILE__), '..', '..', 'fixtures', file_name))
        end

        let(:success_response) do
          {
            status: 200,
            body: {
              'bucketKey' => 'testmla',
              'objectId' => 'urn:adsk.objects:os.object:testmla/Locker.3DS',
              'objectKey' => 'Locker.3DS',
              'sha1' => '7ee3cc022822961513b3b64a6cf3f78fb34cbf5d',
              'size' => 44,
              'contentType' => 'application/x-www-form-urlencoded',
              'location' => 'https://developer.api.autodesk.com/oss/v2/buckets/testmla/objects/Locker.3DS'
            }.to_json,
            headers: {
              'Content-Type' => 'application/json'
            }
          }
        end

        it 'requires bucket_key and file as arguments' do
          proc { client.upload_file }.must_raise ArgumentError
          proc { client.upload_file('bucket') }.must_raise ArgumentError
        end

        it 'returns Hash' do
          stub_request(:put,
                       "#{Endpoint::BUCKETS}/#{bucket}/objects/#{file_name}")
            .with(headers: request_headers).to_return(success_response)

          assert client.upload_file(bucket, upload_file).is_a? Hash
        end

        it 'returns objectId' do
          stub_request(:put,
                       "#{Endpoint::BUCKETS}/#{bucket}/objects/#{file_name}")
            .with(headers: request_headers).to_return(success_response)

          upload = client.upload_file(bucket, upload_file)
          assert upload['objectId'].is_a? String
        end

        it 'returns location' do
          stub_request(:put,
                       "#{Endpoint::BUCKETS}/#{bucket}/objects/#{file_name}")
            .with(headers: request_headers).to_return(success_response)

          upload = client.upload_file(bucket, upload_file)
          assert upload['location'].is_a? String
        end
      end
    end
  end
end
