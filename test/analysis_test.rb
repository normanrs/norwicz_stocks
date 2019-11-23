require 'minitest/autorun'
require 'minitest/pride'
require './lib/analysis.rb'

class AnalysisTest < Minitest::Test

  def setup
    @analysis = Analysis.new
  end

  def test_job_created
    assert @analysis
  end

  def test_write_statements
    @analysis.read_fmp_json
  end

end
