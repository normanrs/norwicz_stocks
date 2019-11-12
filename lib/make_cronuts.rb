require './lib/import_data.rb'
require './lib/item.rb'
require './lib/batter.rb'
require './lib/topping.rb'

class MakeCronuts
  include ImportData

	attr_reader :data_in, :batters, :toppings, :items, :batters_list, :toppings_list

  def startup_data(path)
    @data_in ||= import_json(path)[:items][:item]
  end

  def make_items
    @items = []
    @data_in.each do |item|
      item_data = {id: item[:id],
                 type: item[:type],
                 name: item[:name],
                  ppu: item[:ppu]
                  }
      new_1 = Item.new(item_data)
      new_1.batters << make_batters(item)
      new_1.toppings << make_toppings(item)
      @items << new_1
    end
  end

  def make_batters(item_in)
    item_in[:batters][:batter].map do |batter_data|
      Batter.new(batter_data)
    end
  end

  def make_toppings(item_in)
    item_in[:topping].map do |topping_data|
      Topping.new(topping_data)
    end

  end

  def list_ingredients
    @batters_list  = list_batters
    @toppings_list = list_toppings
  end

  def list_batters
    ingredients_out = []
    @data_in.each do |item|
      item[:batters].each do |batter|
        batter[1].each do |ingredient|
          ingredients_out << ingredient[:type]
        end
      end
    end
    ingredients_out.uniq
  end

  def list_toppings
    ingredients_out = []
    @data_in.each do |item|
      item[:topping].each do |ingredient|
        ingredients_out << ingredient[:type]
      end
    end
    ingredients_out.uniq
  end

end
