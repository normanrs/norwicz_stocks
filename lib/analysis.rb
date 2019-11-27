require 'json'
require 'csv'
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
      stock['financials'].each do |financial|
        financial.transform_keys! {|k| k.gsub(/\W+/, '')} 
        financial.merge!add_data(financial)
        delete_data.each do |data| 
          financial.delete(data)
        end
        financial['date'] = financial['date'][0..3].to_i
        financial.transform_values! {|v| v.to_f.round(3) }
      end
      result << Stock.new(stock)
    end
    result
  end

  def add_data(fin_hash) 
    hash_out = fin_hash['investmentValuationRatios']
    hash_out.merge!(fin_hash['profitabilityIndicatorRatios'])
    hash_out.merge!(fin_hash['operatingPerformanceRatios'])
    hash_out.merge!(fin_hash['debtRatios'])
    hash_out.merge!(fin_hash['cashFlowIndicatorRatios'])
  end

  def delete_data
    %w[ investmentValuationRatios
        liquidityMeasurementRatios
        profitabilityIndicatorRatios
        operatingPerformanceRatios
        debtRatios
        cashFlowIndicatorRatios
      ]
  end

  def write_data
    result = []
    stocks.each do |stock| 
      my_data(stock)
      column_header = stock.financials.first.keys
      CSV.open("output/#{stock.symbol}.csv", "wb", :write_headers=> true, :headers => column_header) do |csv| 
        stock.financials.each do |financial| 
          csv << financial.values
        end
      end
    end
  end

  def my_data(stock)
    stock.financials.each do |financial|
      ffo_calc(financial)
      financial.keep_if {|key,_| keep_keys.include? key }
    end
  end

  def keep_keys 
    %w[
        date
        EBITDAMargin
        NetProfitMargin
        dividendYield
        dividendPayoutRatio
        cashFlowToDebtRatio
        operatingCashFlowPerShare
        priceCashFlowRatio
        returnOnEquity
        debtEquityRatio
        ffo
      ]
  end

  def ffo_calc(financial)
    ebitda = financial['EBITDA']
    depre_amort = financial['DepreciationAmortization']
    acquisition = financial['Acquisitionsanddisposals']
    ffo = (ebitda + depre_amort - acquisition)
    add_ffo = {'ffo' => ffo }
    financial.merge!(add_ffo)
  end

end
