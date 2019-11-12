require 'minitest/autorun'
require 'minitest/pride'
require './lib/topping.rb'

class ToppingTest < Minitest::Test

  def test_item_creation
    topping_regular   = { :id => "5002", :type => "Glazed" }
    topping_1 = Topping.new(topping_regular)
    assert_equal 5002, topping_1.id
    assert_equal "Glazed", topping_1.type
  end

end
