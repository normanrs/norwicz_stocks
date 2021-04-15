# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/analysis.rb'

class AnalysisTest < Minitest::Test
  def setup
    skip
    @analysis = Analysis.new
  end

  def test_job_created
    assert @analysis
  end

  def test_stock_population
    refute_empty @analysis.stocks
  end

  def test_stock_data
    @analysis.write_data
  end
end
