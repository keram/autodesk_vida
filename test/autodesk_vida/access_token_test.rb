require_relative '../test_helper'

require 'autodesk_vida/access_token'

module AutodeskVida
  describe 'AccessToken' do
    let(:token_options) do
      { 'access_token' => 'xx', 'token_type' => 'tt', 'expires_in' => 1 }
    end

    describe '#initialize' do
      describe 'missing arguments' do
        it 'raise ArgumentError' do
          proc { AccessToken.new }.must_raise ArgumentError
        end
      end

      describe 'invalid arguments' do
        it 'require passed access_token' do
          proc { AccessToken.new(nil) }.must_raise NoMethodError
        end
      end

      describe 'missing access_token key' do
        it 'raise KeyError' do
          proc { AccessToken.new({}) }.must_raise KeyError
        end
      end

      it 'returns instance of AccessToken' do
        AccessToken.new(token_options).must_be_instance_of AccessToken
      end
    end

    describe '#expired?' do
      describe 'expires_in is in past' do
        it 'returns true' do
          token = AccessToken.new token_options.merge('expires_in' => -1)

          assert token.expired?
        end
      end

      describe 'expires_in is in future' do
        it 'returns false' do
          token = AccessToken.new token_options.merge('expires_in' => 100)

          assert !token.expired?
        end
      end

      describe '#to_s' do
        it 'returns token type with access_token' do
          token = AccessToken.new token_options

          assert_equal token.to_s, 'tt xx'
        end
      end
    end
  end
end
