require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test

  def setup
    @job = WriteFinanacials.new
  end

  def test_job_created
    assert @job
  end

  def test_write_statements
    skip "Data already exists"
    @job.write_statements('fmp')
  end

end
