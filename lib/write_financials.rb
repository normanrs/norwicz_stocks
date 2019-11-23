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
      SPG
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
      ACB
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
        new_financial = []
        financial = api_call(fmp_financials, stock)
        cashflow  = api_call(fmp_cashflow, stock)['financials']
        ratios    = api_call(fmp_ratios, stock)['ratios']
        financial['financials'][0..3].each do |annual| 
          cash  = cashflow.find { |r| r['date'] == annual['date'] }
          ratio = ratios.find { |r| r['date'] == annual['date'] }
          annual.merge!(cash).merge!(ratio)
          new_financial << annual
        end
        new_hash = {'symbol' => stock, 'financials' => new_financial}
        responses << new_hash
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


end
