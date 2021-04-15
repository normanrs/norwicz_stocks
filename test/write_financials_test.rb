# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test
  def setup; end

  def test_write_statements
    write_time = WriteFinancials.write_statements
    assert_instance_of Time, write_time
  end

  def test_update_reit_data
    updated_data = WriteFinancials.update_reit_data({})
    assert_nil updated_data
  end
end
