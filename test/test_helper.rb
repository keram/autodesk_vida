$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
end

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'
require 'byebug'
require 'autodesk_vida'

module Minitest
  Reporters.use! [Reporters::DefaultReporter.new(color: true)]
end
