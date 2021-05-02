# frozen_string_literal: true

require 'deep_merge'
require 'net/http'
require_relative 'data_helper'
require_relative 'request_helper'
require_relative 'write_helper'

class WriteFinancials
  class << self
    include RequestHelper
    include WriteHelper
    include DataHelper
    extend DataHelper

    BUCKET = config.dig('bucket')
    FILENAME = config.dig('filename')
    FMP_ODD_DAY = '/key-metrics-ttm/'
    FMP_EVEN_DAY = '/rating/'
    DAY = Date.today.day

    def top_picks
      financial_data = JSON.parse(File.read('data/stock_data.json'), {})
      top_stocks = {
        reits: top_reits(financial_data)
      }
      write_json('data/top_stocks.json', top_stocks)
      top_stocks
    end

    def write_statements
      if !File.exist?(FILENAME)
        # Force update to populate all data
        puts 'Getting new financial data'
        update_stock_data({})
      elsif (Time.now - File.mtime(FILENAME)) < 86_400
        # Do not update financials less than 1 day old or 86_400 seconds
        puts 'Financial data is up-to-date'
      else
        puts 'Updating existing financial data'
        existing_financials = JSON.parse(File.read(FILENAME), {})
        update_stock_data(existing_financials)
      end
      File.mtime(FILENAME)
    end

    def update_stock_data(existing_data)
      existing_data.transform_keys! { |key| key.to_s.downcase }
      write_data = merge_hashes(existing_data, new_financials)
      write_json(FILENAME, write_data)
      write_csv(write_data)
    end

    def merge_hashes(hash1, hash2)
      hash1.deep_merge(hash2)
    end

    def new_financials
      # FMP site limits calls with free membership, so this will
      # write half the data one day and the rest another day
      DAY.odd? ? financials(FMP_ODD_DAY) : financials(FMP_EVEN_DAY)
    end

    def financials(call)
      new_hash = {}
      stock_list.each do |stock|
        new_data = call_fmp(call, stock)
        next unless new_data.any?

        new_hash[stock] = new_data
      end
      new_hash
    end

  end
end
