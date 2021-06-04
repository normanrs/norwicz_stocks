# frozen_string_literal: true

require './test/test_helper.rb'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test
  include WriteHelper
  def setup; end

  def test_write_statements
    write_time = WriteFinancials.write_statements
    assert_instance_of Time, write_time
  end

  def test_merge_updates_data
    hash1 = JSON.parse(File.read('./test/data/stock_data.json'), {})
    hash2 = JSON.parse(File.read('./test/data/stock_data2.json'), {})
    merged = WriteFinancials.merge_hashes(hash1, hash2)
    assert_equal hash1.count, merged.count
    assert_equal "Dont Buy", merged.dig('AAPL', 'ratingrecommendation')
  end

  def test_merge_adds_data
    hash1 = JSON.parse(File.read('./test/data/stock_data2.json'), {})
    hash2 = JSON.parse(File.read('./test/data/stock_data.json'), {})
    merged = WriteFinancials.merge_hashes(hash1, hash2)
    assert merged.dig('AAPL').keys.count > 2
  end

  def test_top_picks
    test_method = WriteFinancials.top_picks
    refute_empty test_method
  end
end
