require 'bigdecimal'
require './lib/batter.rb'
require './lib/topping.rb'

class Item

    	attr_reader :id,
    							:name,
                  :type,
                  :ppu,
                  :toppings,
                  :batters

  	def initialize(data, toppings = [], batters = [])
  		@id       = data[:id].to_i
  		@name     = data[:name]
      @type     = data[:type]
      @ppu      = BigDecimal(data[:ppu].to_s)
      @toppings = toppings
      @batters  = batters
  	end

end
