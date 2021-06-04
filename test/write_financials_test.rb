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

  def test_top_picks
    test_method = WriteFinancials.top_picks
    refute_empty test_method
  end
end
