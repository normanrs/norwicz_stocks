# frozen_string_literal: true

require './test/test_helper.rb'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_helper.rb'

class RequestHelperTest < Minitest::Test
  include RequestHelper

  def setup; end

  def test_api_call
    test_api = 'https://jsonplaceholder.typicode.com/todos/1'
    test_method = api_call(URI.parse(test_api))
    assert_equal 200, test_method.code.to_i
    refute_empty JSON.parse(test_method.body)
  end

  def test_call_fmp
    test_path = '/profile/'
    test_stock = 'AAPL'
    test_method = call_fmp(test_path, test_stock)
    refute_empty test_method
  end

  def test_fmp_clean
    test_method = fmp_clean(sample_fmp_data)
    refute test_method.dig('inventoryturnoverttm')
    refute test_method.dig('researchanddevelopementtorevenuettm')
    refute test_method.dig('daysofinventoryonhandttm')
    refute test_method.dig('averageinventoryttm')
    assert_empty(test_method.select { |k, _v| k =~ /[A-Z]/ })
  end
end
