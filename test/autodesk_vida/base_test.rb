require_relative '../test_helper'

require 'autodesk_vida/base'

module AutodeskVida
  class Successor < Base; end
  Endpoint::SUCCESSOR = 'xxx'

  describe 'Base' do
    describe '.endpoint' do
      it 'returns instance of URI' do
        assert Base.endpoint.is_a? URI
      end
    end

    describe '#endpoint' do
      it 'equals to .endpoint' do
        Base.new.endpoint.must_equal Base.endpoint
      end
    end

    describe 'Successor' do
      describe '.endpoint' do
        it 'returns sucessor endpoint uri' do
          Successor.endpoint.must_equal URI(Endpoint::SUCCESSOR)
        end
      end

      describe '#endpoint' do
        it 'equals to Successor.endpoint' do
          Successor.new.endpoint.must_equal Successor.endpoint
        end
      end
    end
  end
end
