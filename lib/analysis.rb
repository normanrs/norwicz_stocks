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
      end
      result << Stock.new(stock)
    end
    result
  end

  def write_data
    result = []
    stocks.each do |stock| 
      CSV.open("data/#{stock.symbol}.csv", "wb") do |csv| 
        stock.financials.each do |financial| 
          csv << my_data(financial)
        end
      end
    end
  end

  def my_data(data) 
    require 'pry'; binding.pry
  end

  def keep_keys 
    ["date",
      "Revenue",
      "Revenue Growth",
      "Cost of Revenue",
      "Gross Profit",
      "Operating Expenses",
      "Operating Income",
      "Interest Expense",
      "Earnings before Tax",
      "Income Tax Expense",
      "Net Income",
      "Preferred Dividends",
      "Net Income Com",
      "EPS",
      "EPS Diluted",
      "Weighted Average Shs Out",
      "Weighted Average Shs Out (Dil)",
      "Dividend per Share",
      "Gross Margin",
      "EBITDA Margin",
      "EBIT Margin",
      "Profit Margin",
      "Free Cash Flow margin",
      "EBITDA",
      "EBIT",
      "Consolidated Income",
      "Earnings Before Tax Margin",
      "Net Profit Margin",
      "Depreciation & Amortization",
      "Stock-based compensation",
      "Operating Cash Flow",
      "Capital Expenditure",
      "Acquisitions and disposals",
      "Investment purchases and sales",
      "Investing Cash flow",
      "Issuance (repayment) of debt",
      "Issuance (buybacks) of shares",
      "Dividend payments",
      "Financing Cash Flow",
      "Effect of forex changes on cash",
      "Net cash flow / Change in cash",
      "Free Cash Flow",
      "Net Cash/Marketcap",
      "investmentValuationRatios",
      "profitabilityIndicatorRatios",
      "operatingPerformanceRatios",
      "liquidityMeasurementRatios",
      "debtRatios",
      "cashFlowIndicatorRatios"]
  end

  def ffo_calc 
    [
      "Net Income",
      "Depreciation & Amortization",
      "Acquisitions and disposals",
    ]
  end

end
