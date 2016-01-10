require_relative '../test_helper'

require 'autodesk_vida/request'

module AutodeskVida
  describe 'Request' do
    describe '::USER_AGENT' do
      let(:user_agent) { Request::USER_AGENT }

      it 'ruby engine' do
        assert_includes user_agent, RUBY_ENGINE
      end

      it 'ruby version' do
        assert_includes user_agent, RUBY_VERSION
      end

      it 'includes gem name' do
        assert_includes user_agent, 'AutodeskVida'
      end

      it 'includes gem version' do
        assert_includes user_agent, AutodeskVida::VERSION
      end
    end
  end
end
