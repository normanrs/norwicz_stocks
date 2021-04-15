# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

require 'csv'
require 'json'
require 'net/http'
require_relative 'request_helper'
require_relative 'data_helper'

class WriteFinanacials
  include RequestHelper
  include DataHelper

  FILENAME = "data/reit_data.json"
  FMP_RATIOS = '/ratios-ttm/'
  FMP_METRICS = '/key-metrics-ttm/'

  def write_statements
    file_exists = File.exist?(FILENAME)
    update_reit_data({}) unless file_exists
    file_age = Time.now - File.ctime(FILENAME)
    # Do not update financials less than 1 day old or 86_400 seconds
    if file_age < 10
      puts 'Financial statements are up-to-date'
    else
      existing_financials = JSON.parse(File.read(FILENAME), {})
      update_reit_data(existing_financials)
    end
  end

  private

  def update_reit_data(existing_data)
    # FMP site limits calls with free membership, so this will
    # write half the data one day and the rest another day
    new_financials = {}
    if Date.today.day.odd?
      new_financials = financials(FMP_RATIOS)
    else
      new_financials = financials(FMP_METRICS)
    end
    new_financials.each do |key, value|
      new_financials[key].merge!(existing_data[key])
    end
    require 'pry'; binding.pry
    write_hash = new_financials
    write_json(write_hash)
  end

  def write_json(hash_in)
    filename = "data/reit_data.json"
    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate(hash_in, indent: "\t", object_nl: "\n"))
    end
  end

  def stocks
    stock_list.join(',')
  end

  def financials(call)
    new_hash = {}
    test_stock.each do |stock|
      new_hash[stock] = financial_update(stock, call)
    end
    new_hash
  end

  def financial_update(stock, call)
    call_fmp(call, stock) || {}
  end

end
# rubocop:enable Metrics/PerceivedComplexity
