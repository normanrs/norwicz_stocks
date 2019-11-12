require 'minitest/autorun'
require 'minitest/pride'
require './lib/batter.rb'

class BatterTest < Minitest::Test

  def test_item_creation
    batter_regular   = { :id => "1001", :type => "Regular" }
    batter_1         = Batter.new(batter_regular)
    assert_equal 1001, batter_1.id
    assert_equal "Regular", batter_1.type
  end

end
