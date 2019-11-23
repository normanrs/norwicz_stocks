require 'net/http'
require 'uri'
require 'json'
require_relative 'request_helper'

class WriteFinanacials
  include RequestHelper

  def write_statements(name)
    write_json(name, statements)
  end

  private

  def write_json(type, hash)
    File.open("data/#{type}_data.json", 'w') do |f|
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
