require 'minitest/autorun'
require 'minitest/pride'
require './lib/make_cronuts.rb'

class MakeCronutsTest < Minitest::Test

  def setup
    @job      = MakeCronuts.new
    @data     = @job.startup_data("./data/cronut.json")
  end

  def test_it_starts_with_json_data
    actual   = @data.count
    expected = 3

    assert_equal expected, actual
  end

  def test_it_makes_batters
    item_1 = @job.data_in.first
    batters = @job.make_batters(item_1)

    assert_equal 4, batters.count
  end

  def test_it_makes_toppings
    item_1 = @job.data_in.first
    toppings = @job.make_toppings(item_1)

    assert_equal 7, toppings.count
  end

  def test_it_makes_nested_items
    @job.make_items
    item_1 = @job.items[0]
    item_2 = @job.items[1]
    item_3 = @job.items[2]

    assert_equal 3, @job.items.count
    assert_equal "Cake", item_1.name
    assert_equal "Pastry", item_2.name
    assert_equal "Cake", item_3.name
  end

  def test_it_lists_ingredients
    @job.list_ingredients

    assert_equal 6, @job.batters_list.count
    assert_equal 7, @job.toppings_list.count
  end

end
