# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/stock.rb'

class StockTest < Minitest::Test
  def test_item_creation
    stock_data = { id: 'APLE', last_year_earnings_thousands: 10_999 }
    stock_one = Stock.new(stock_data)
    assert_equal 'APLE', stock_one.id
    assert_equal 10_999, stock_one.last_year_earnings_thousands
  end
end
