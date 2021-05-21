# frozen_string_literal: true

require './test/test_helper.rb'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_helper.rb'

class WriteHelperTest < Minitest::Test
  include WriteHelper

  def setup; end

  def test_write_json
    test_file = 'tmp/write_helper.json'
    safe_delete(test_file)
    write_json(test_file, sample_fmp_data)
    assert File.exist?(test_file)
  end

  def test_write_csv
    test_file = 'tmp/write_helper.csv'
    safe_delete(test_file)
    headers = sample_fmp_data.values.first.keys.unshift('TICKER')
    write_csv(test_file, headers, sample_fmp_data)
    assert File.exist?(test_file)
  end

  def test_pull_dir_from_s3
    test_method = pull_dir_from_s3('data')
    assert_instance_of Array, test_method
  end
end
