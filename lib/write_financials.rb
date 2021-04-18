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

    def write_statements
      if !File.exist?(FILENAME)
        # Force update to populate all data
        puts 'Writing new financial statements'
        update_reit_data({})
      elsif (Time.now - File.mtime(FILENAME)) < 86_400
        # Do not update financials less than 1 day old or 86_400 seconds
        puts 'Financial statements are up-to-date'
      else
        puts 'Updating existing financial data'
        existing_financials = JSON.parse(File.read(FILENAME), {})
        update_reit_data(existing_financials)
      end
      File.mtime(FILENAME)
    end

    def update_reit_data(existing_data)
      write_data = merge_hashes(existing_data, new_financials)
      write_json(write_data)
      push_to_s3(FILENAME) unless ARGV.include?('local')
    end

    def merge_hashes(hash1, hash2)
      hash1.deep_merge(hash2)
    end

    def new_financials
      # FMP site limits calls with free membership, so this will
      # write half the data one day and the rest another day
      found = if Date.today.day.odd?
                financials(FMP_RATIOS)
              else
                financials(FMP_METRICS)
              end
      return unless found.any?
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
      call_fmp(call, stock) || {}
    end

    def write_json(hash_in)
      File.open(FILENAME, 'w') do |f|
        f.write(JSON.pretty_generate(hash_in, indent: "\t", object_nl: "\n"))
      end
    end

    def push_to_s3(path_filename)
      s3 = Aws::S3::Resource.new(region: 'us-east-1')
      obj = s3.bucket(BUCKET).object(path_filename.to_s)
      obj.upload_file(path_filename.to_s)
    end
  end
end

# WriteFinancials.write_statements
