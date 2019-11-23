require 'json'
require_relative 'stock'

class Analysis

  def read_fmp_json
    file = File.read("data/fmp_data.json")
    # hash = JSON.parse(file)
    require 'pry'; binding.pry
  end

end
