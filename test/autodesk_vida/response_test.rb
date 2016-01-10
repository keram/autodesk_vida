require_relative '../test_helper'
require 'autodesk_vida/errors'

module AutodeskVida
  describe 'Response' do
    describe 'HTTPCreated' do
      it 'returns parsed json string' do
        hash = { 'a' => 1 }

        assert_equal(
          hash, Response.respond(hash.to_json, 'application/json', 201)
        )
      end
    end

    describe 'HTTPNoContent' do
      it 'returns empty Hash' do
        assert_equal(
          {}, Response.respond('', 'application/json', 205)
        )
      end
    end

    describe 'HTTPBadRequest' do
      it 'raise BadRequest error' do
        proc do
          Response.respond({}.to_json, 'application/json', 400)
        end.must_raise BadRequestError
      end
    end

    describe 'HTTPUnauthorized' do
      it 'raise Unauthorized error' do
        proc do
          Response.respond({}.to_json, 'application/json', 401)
        end.must_raise UnauthorizedError
      end
    end

    describe 'HTTPNotFound' do
      it 'raise NotFound error' do
        proc do
          Response.respond({}.to_json, 'application/json', 404)
        end.must_raise NotFoundError
      end
    end

    describe 'HTTPConflict' do
      it 'raise Conflict error' do
        proc do
          Response.respond({}.to_json, 'application/json', 409)
        end.must_raise ConflictError
      end
    end

    describe 'HTTPUnsupportedMediaType' do
      it 'raise UnsupportedMediaType error' do
        proc do
          Response.respond({}.to_json, 'application/json', 415)
        end.must_raise UnsupportedMediaTypeError
      end
    end

    describe 'HTTPInternalServerError' do
      it 'raise InternalServer error' do
        proc do
          Response.respond({}.to_json, 'application/json', 500)
        end.must_raise InternalServerError
      end
    end

    describe 'HTTPGatewayTimeout' do
      it 'raise ServiceUnavailable error' do
        proc do
          Response.respond({}.to_json, 'application/json', 504)
        end.must_raise ServiceUnavailableError
      end
    end
  end
end
