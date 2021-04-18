# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './test/test_helper.rb'
require './lib/data_helper.rb'

class DataHelperTest < Minitest::Test
  include DataHelper
  extend DataHelper

  def setup; end

  def test_stock_list
    test_method = stock_list
    refute_empty test_method
  end

  def test_reits
    test_method = reits
    refute_empty test_method
  end

  def test_config
    test_method = config
    refute_empty test_method
  end

  def test_env_config_defaults_to_dev
    ENV['CONFIG'] = nil
    assert_equal 'dev', env_config
  end

  def test_load_yaml
    test_method = config
    assert_instance_of Hash, test_method
  end
end
