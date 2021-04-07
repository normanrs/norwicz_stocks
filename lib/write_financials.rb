# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

require 'json'
require 'net/http'
require_relative 'request_helper'

class WriteFinanacials
  include RequestHelper

  def write_statements(name)
    filename = "data/#{name}_data.json"
    file = File.open(filename, 'w')
    file_age = Time.now - file.mtime
    if file_age < 604_800
      puts 'Financial statements are up-to-date'
    else
      write_json(name, financials)
    end
  end

  private

  FMP_INCOME = '/financials/income-statement/'

  FMP_CASHFLOW = '/financials/cash-flow-statement/'

  FMP_RATIOS = '/financial-ratios/'

  FMP_VALUE = '/enterprise-value/'

  FMP_METRICS = '/company-key-metrics/'

  FMP_RATING = '/company/rating/'

  def write_json(type, hash)
    filename = "data/#{type}_data.json"
    File.open(filename, 'w') do |f|
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
        new_hash = { 'symbol' => stock, 'financials' => financial_update(stock) }
        responses << new_hash
      rescue StandardError => e
        puts "Error building #{stock} data: #{e.message}"
      end
      responses
    end
  end

  def financial_update(stock)
    new_financial = []
    financial = call_fmp(FMP_INCOME, stock)
    cashflow  = call_fmp(FMP_CASHFLOW, stock)['financials'] || {}
    ratios    = call_fmp(FMP_RATIOS, stock)['ratios'] || {}
    values    = call_fmp(FMP_VALUE, stock)['enterpriseValues'] || {}
    metrics   = call_fmp(FMP_METRICS, stock)['metrics'] || {}
    financial['financials'][0..3].each do |annual|
      cash   = cashflow.find { |r| r['date'] == annual['date'] } || {}
      ratio  = ratios.find { |r| r['date'] == annual['date'] } || {}
      value  = values.find { |r| r['date'] == annual['date'] } || {}
      metric = metrics.find { |r| r['date'] == annual['date'] } || {}
      annual.merge!(cash).merge!(ratio).merge!(value).merge!(metric)
      new_financial << annual
    end
    new_financial
  end

end
# rubocop:enable Metrics/PerceivedComplexity
