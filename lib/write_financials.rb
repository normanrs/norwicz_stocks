require 'net/http'
require 'uri'
require 'json'
require_relative 'request_helper'

class WriteFinanacials
  include RequestHelper

  def write_statements(name)
    write_json(name, financials)
  end

  private

  def write_json(type, hash)
    File.open("data/#{type}_data.json", 'w') do |f|
      f.write(JSON.pretty_generate(hash, indent: "\t", object_nl: "\n"))
    end
  end

  def stock_list 
    %w[
      NRZ
      GNL
      PLYM
      SBRA
      STWD
      CLNY
      WSR
      CIO
      GMRE
      LXP
      APLE
      SRC
      GOOD
      IRT
      VER
      BRG
      APTS
      EPD
      MPW
      MGP
      SLM
      COLD
      ]
  end

  def stocks 
    stock_list.join(',')
  end

  def financials
    @financials ||= begin
      responses = []
      stock_list.each do |stock|
        begin
          new_financial = []
          financial = api_call(fmp_financials, stock)
          cashflow  = api_call(fmp_cashflow, stock)['financials'] || {}
          ratios    = api_call(fmp_ratios, stock)['ratios'] || {}
          values    = api_call(fmp_value, stock)['enterpriseValues'] || {}
          metrics   = api_call(fmp_metrics, stock)['metrics'] || {}
          financial['financials'][0..3].each do |annual| 
            cash   = cashflow.find { |r| r['date'] == annual['date'] } || {}
            ratio  = ratios.find { |r| r['date'] == annual['date'] } || {}
            value  = values.find { |r| r['date'] == annual['date'] } || {}
            metric = metrics.find { |r| r['date'] == annual['date'] } || {}
            annual.merge!(cash).merge!(ratio).merge!(value).merge!(metric)
            new_financial << annual
          end
          new_hash = { 'symbol' => stock, 'financials' => new_financial }
          responses << new_hash
        rescue => e
          puts "Error building #{stock} data: #{e.message}"
        end
      end
      responses
    end 
  end

  def fmp_financials
    URI.parse("https://financialmodelingprep.com/api/v3/financials/income-statement/") 
  end
  
  def fmp_cashflow
    URI.parse("https://financialmodelingprep.com/api/v3/financials/cash-flow-statement/") 
  end

  def fmp_ratios 
    URI.parse("https://financialmodelingprep.com/api/v3/financial-ratios/")
  end

  def fmp_value 
    URI.parse("https://financialmodelingprep.com/api/v3/enterprise-value/")
  end

  def fmp_metrics 
    URI.parse("https://financialmodelingprep.com/api/v3/company-key-metrics/")
  end

  def fmp_rating 
    URI.parse("https://financialmodelingprep.com/api/v3/company/rating/")
  end

end
