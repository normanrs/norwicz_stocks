require 'net/http'
require 'uri'

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

  def api_call(url, stock)
    uri = url + stock
    request = Net::HTTP::Get.new(uri)
    request["Upgrade-Insecure-Requests"] = "1"
    req_options = { use_ssl: uri.scheme == "https", }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end 
    JSON.parse(response.body)
  end

end