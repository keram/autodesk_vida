require_relative '../test_helper'

module AutodeskVida
  describe 'Client' do
    describe '#initialize' do
      let(:credentials) { { client_id: 1, client_secret: 2, grant_type: 3 } }

      it 'instatiate instance of client' do
        client = Client.new credentials

        assert client.is_a? Client
      end

      # TODO: fill this test
      it 'require credentials' do
        Client.new credentials
      end
    end
  end
end
