# frozen_string_literal: true

require './test/test_helper.rb'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_helper.rb'

class WriteHelperTest < Minitest::Test
  include WriteHelper

  def setup; end

  def test_write_json
    test_method = write_json('tmp/write_helper.json', sample_fmp_data)
    assert_instance_of Integer, test_method
  end
end
