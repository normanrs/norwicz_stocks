# frozen_string_literal: true

require 'aws-sdk-s3'
require 'deep_merge'
require 'csv'
require 'json'
require 'net/http'
require_relative 'request_helper'
require_relative 'data_helper'

class WriteFinancials
  class << self
    include RequestHelper
    include DataHelper
    extend DataHelper

    BUCKET = config.dig('bucket')
    FILENAME = config.dig('filename')
    FMP_RATIOS = '/ratios-ttm/'
    FMP_METRICS = '/key-metrics-ttm/'
    DAY = Date.today.day

    def top_picks
      financial_data = JSON.parse(File.read('data/reit_data.json'), {})
      top_stocks = financial_data.select do |key, value|
        value['dividendYieldTTM'].to_f > 0.05 &&
          value['roeTTM'].to_f > 0.10
      end.keys
      write_json('data/top_stocks.json', top_stocks)
      top_stocks
    end

    def write_statements
      if !File.exist?(FILENAME)
        # Force update to populate all data
        puts 'Getting new financial data'
        update_reit_data({})
      elsif (Time.now - File.mtime(FILENAME)) < 86_400
        # Do not update financials less than 1 day old or 86_400 seconds
        puts 'Financial data is up-to-date'
      else
        puts 'Updating existing financial data'
        existing_financials = JSON.parse(File.read(FILENAME), {})
        update_reit_data(existing_financials)
      end
      File.mtime(FILENAME)
    end

    def update_reit_data(existing_data)
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
      DAY.odd? ? financials(FMP_RATIOS) : financials(FMP_METRICS)
    end

    def financials(call)
      new_hash = {}
      stock_list.each do |stock|
        new_data = financial_update(stock, call)
        next unless new_data.any?

        new_hash[stock] = new_data
      end
      new_hash
    end

    def financial_update(stock, call)
      data_type = DAY.odd? ? 'ratios' : 'metrics'
      result = call_fmp(call, stock) || {}
      write_json("tmp/#{data_type}-#{stock}.json", result)
      result
    end

    def write_json(filename, hash_in)
      puts "Writing #{filename}"
      File.open(filename, 'w') do |f|
        f.write(JSON.pretty_generate(hash_in, indent: "\t", object_nl: "\n"))
      end
    end

    def write_csv(hash_in)
      headers = (hash_in.values.first.keys).unshift('TICKER')
      CSV.open("data/reit_data.csv", 'wb', write_headers: true, headers: headers) do |csv|
        hash_in.each do |key, data|
          csv << data.values.unshift(key)
        end
      end
    end

    def push_to_s3(dir)
      Dir.glob("#{dir}/*.*").each do |path_filename|
        puts "Writing #{path_filename} to S3 bucket"
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        obj = s3.bucket(BUCKET).object(path_filename.to_s)
        obj.upload_file(path_filename.to_s)
      end
    end
  end
end

# WriteFinancials.write_statements
