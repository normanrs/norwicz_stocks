# frozen_string_literal: true

require 'dotenv'
require 'net/http'
require 'uri'
Dotenv.load('token.env')

module RequestHelper
  def request(method, path, options = {}, url = BASE_URL)
    # Builds a request with parameters and returns the last response
    build_request(method, url, path)
    unless options.empty?
      add_params(options.fetch(:params, {}),
                 options.fetch(:headers, {}),
                 options)
    end
    respond
  end

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
    uri = URI.parse(site + path + stock + "?apikey=#{fmp_key}")
    response = api_call(uri)
    puts "#{stock} #{path} returned #{response.code}"
    if response.code == '200'
      raw = JSON.parse(response.body).first
      fmp_clean(raw)
    else
      {}
    end
  end

  def fmp_clean(raw_data)
    result = raw_data.transform_keys { |key| key.to_s.downcase }
    result.delete('inventoryturnoverttm')
    result.delete('researchanddevelopementtorevenuettm')
    result.delete('daysofinventoryonhandttm')
    result.delete('averageinventoryttm')
    result
  end
end
