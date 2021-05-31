# frozen_string_literal: true

require './test/test_helper.rb'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test
  def setup; end

  def test_write_statements
    write_time = WriteFinancials.write_statements
    assert_instance_of Time, write_time
  end

  def test_merge_hashes
    hash1 = JSON.parse(File.read("./test/data/stock_data.json"), {})
    hash2 = JSON.parse(File.read("./test/data/stock_data2.json"), {})
    test_method = WriteFinancials.merge_hashes(hash1, hash2)
    assert test_method['AAT'].count == 2
  end

  def test_top_picks
    test_method = WriteFinancials.top_picks
    puts test_method
    refute_empty test_method
  end
end
