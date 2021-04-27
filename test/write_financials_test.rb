# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './test/test_helper.rb'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test
  def setup; end

  def test_write_statements
    write_time = WriteFinancials.write_statements
    assert_instance_of Time, write_time
  end

  def test_merge_hashes
    hash1 = { 'AAT' => { 'wth' => 11 } }
    hash2 = { 'AAT' => { 'wtf' => 42 } }
    test_method = WriteFinancials.merge_hashes(hash1, hash2)
    assert test_method['AAT'].count == 2
  end

  def test_top_picks
    test_method = WriteFinancials.top_picks
    refute_empty test_method
  end
end
