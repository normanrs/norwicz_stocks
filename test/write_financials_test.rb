require 'minitest/autorun'
require 'minitest/pride'
require './lib/write_financials.rb'

class WriteFinancialsTest < Minitest::Test

  def setup
    @job = WriteFinanacials.new
  end

  def test_presence_of_desired_data
    require 'pry'; binding.pry
  end

end
