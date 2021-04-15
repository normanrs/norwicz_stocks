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

    BUCKET = ENV['AWS_BUCKET']
    FILENAME = 'data/reit_data.json'
    FMP_RATIOS = '/ratios-ttm/'
    FMP_METRICS = '/key-metrics-ttm/'

    def write_statements
      file_exists = File.exist?(FILENAME)
      update_reit_data({}) unless file_exists
      file_age = Time.now - File.mtime(FILENAME)
      # Do not update financials less than 1 day old or 86_400 seconds
      if file_age < 86_400
        puts 'Financial statements are up-to-date'
      else
        existing_financials = JSON.parse(File.read(FILENAME), {})
        update_reit_data(existing_financials)
      end
      File.mtime(FILENAME)
    end

    def update_reit_data(existing_data)
      # FMP site limits calls with free membership, so this will
      # write half the data one day and the rest another day
      new_financials = if Date.today.day.odd?
                         financials(FMP_RATIOS)
                       else
                         financials(FMP_METRICS)
                       end
      return unless new_financials.any?

      existing_data.deep_merge!(new_financials)
      write_json(existing_data)
      push_to_s3(FILENAME)
    end

    def stocks
      stock_list.join(',')
    end

    def financials(call)
      new_hash = {}
      stock_list.each do |stock|
        new_data = financial_update(stock, call)
        next unless new_data.any?

        new_hash[stock] = financial_update(stock, call)
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
