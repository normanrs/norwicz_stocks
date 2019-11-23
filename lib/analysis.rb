require 'json'
require_relative 'stock'

class Analysis
  attr_reader :stocks

  def initialize 
    @stocks = read_fmp_json
  end

  def read_fmp_json
    result = []
    file = File.read("data/fmp_data.json")
    stocks = JSON.parse(file)
    stocks.each do | stock |
      data = stock['financials'].first
      data['symbol'] = stock['symbol']
      data.transform_keys! {|k| k.gsub(/\W+/, '')}
      result << Stock.new(data)
    end
    result
  end

  def ffo 
    
  end

end
