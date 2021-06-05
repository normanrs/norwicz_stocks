# frozen_string_literal: true

require 'dotenv'
require 'net/http'
require 'uri'
require_relative 'data_helper.rb'
Dotenv.load('token.env')

module RequestHelper
  include DataHelper

  def api_call(uri)
    request = Net::HTTP::Get.new(uri)
    request['Upgrade-Insecure-Requests'] = '1'
    req_options = { use_ssl: uri.scheme == 'https' }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  end

  def call_fmp(path, stock)
    fmp_key = env_config == 'dev' ? 'demo' : ENV['TOKEN_FMP']
    site = 'https://financialmodelingprep.com/api/v3'
    uri = URI.parse("#{site}#{path}#{stock}?apikey=#{fmp_key}")
    response = api_call(uri)
    puts "#{stock} #{path} returned #{response.code}"
    if response.code == '200' && no_fmp_error?(response)
      raw = JSON.parse(response.body).first
      fmp_clean(raw)
    else
      puts "Stock #{stock} returned #{response.body}"
      {}
    end
  end

  def no_fmp_error?(response)
    !response.body.include?("Error")
  end

  def fmp_clean(raw_data)
    return {} unless raw_data

    raw_data.transform_keys! { |key| key.to_s.downcase }
    result = raw_data.sort_by { |key, _value| key }.to_h
    result.delete('averageinventoryttm')
    result.delete('date')
    result.delete('daysofinventoryonhandttm')
    result.delete('inventoryturnoverttm')
    result.delete('rating')
    result.delete('ratingdetailsdcfrecommendation')
    result.delete('ratingdetailsdcfscore')
    result.delete('ratingdetailsderecommendation')
    result.delete('ratingdetailsdescore')
    result.delete('ratingdetailspbrecommendation')
    result.delete('ratingdetailspbscore')
    result.delete('ratingdetailsperecommendation')
    result.delete('ratingdetailspescore')
    result.delete('ratingdetailsroarecommendation')
    result.delete('ratingdetailsroascore')
    result.delete('ratingdetailsroerecommendation')
    result.delete('ratingdetailsroescore')
    result.delete('researchanddevelopementtorevenuettm')
    result.delete('symbol')
    result
  end
end
