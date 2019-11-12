require 'net/http'
require 'uri'
require 'json'
require_relative 'request_helper'

class WriteFinanacials
  include RequestHelper

  def initialize
    body = statements
  end

  private

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
      ACB
      SLM
      COLD
      ]
  end

  def stocks 
    stock_list.join(',')
  end

  def statements
    @statements ||= begin
      responses = []
      stock_list.each do |stock|
        uri = fmp_url + stock
        request = Net::HTTP::Get.new(uri)
        request["Upgrade-Insecure-Requests"] = "1"
        req_options = { use_ssl: uri.scheme == "https", }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end 
      responses << JSON.parse(response.body) 
      end
      responses
    end 
  end


  def fmp_url
    URI.parse("https://financialmodelingprep.com/api/v3/financials/income-statement/") 
  end


end
