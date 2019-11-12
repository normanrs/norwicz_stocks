require 'minitest/autorun'
require 'minitest/pride'
require './lib/item.rb'

class ItemTest < Minitest::Test

  def test_item_creation_using_defaults
    item_data = {:id => 1, :type => "donut", :name => "Norm's Famous", :ppu => 0.65 }
    ncronut = Item.new(item_data)
    assert_equal 1, ncronut.id
    assert_equal "Norm's Famous", ncronut.name
    assert_equal "donut", ncronut.type
    assert_equal 0.65, ncronut.ppu
    assert_equal BigDecimal, ncronut.ppu.class
    assert_equal Integer, ncronut.id.class
  end

  def test_can_store_batter_and_topping_options
    batter_regular   = { :id => "1001", :type => "Regular" }
    batter_chocolate = { :id => "1002", :type => "Chocolate" }
    batter_blueberry = { :id => "1003", :type => "Blueberry" }
    topping_none     = { :id => "5001", :type => "None" }
    topping_glazed   = { :id => "5002", :type => "Glazed" }
    item_data_1 = {:id => 1, :name => "Norm's Famous", :type => "donut", :ppu => 0.65 }
    batter_1 = Batter.new(batter_regular)
    batter_2 = Batter.new(batter_chocolate)
    batter_3 = Batter.new(batter_blueberry)
    topping_1 = Topping.new(topping_none)
    topping_2 = Topping.new(topping_glazed)
    ncronut = Item.new(item_data_1)
    ncronut.batters << batter_1
    ncronut.batters << batter_2
    ncronut.batters << batter_3
    ncronut.toppings << topping_1
    ncronut.toppings << topping_2

    assert_equal [batter_1, batter_2, batter_3], ncronut.batters
    assert_equal [topping_1, topping_2], ncronut.toppings
  end

end
