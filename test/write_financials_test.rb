require 'minitest/autorun'
require 'minitest/pride'
require './lib/make_cronuts.rb'

class WriteFinancialsTest < Minitest::Test

  def setup
    @job = WriteFinanacials.new
  end

  def test_presence_of_desired_data
  end

end
