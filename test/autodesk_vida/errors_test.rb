require_relative '../test_helper'
require 'autodesk_vida/errors'

module AutodeskVida
  describe 'ClientError' do
    describe '#initialize' do
      it 'accept one argument' do
        proc { ClientError.new }.must_raise ArgumentError
      end

      describe 'message not given in argument' do
        it 'fallbacks to Error' do
          proc { ClientError.new('test') }.is_a? Error
        end
      end
    end
  end
end
