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

end
