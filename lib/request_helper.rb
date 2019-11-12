require 'rest_client'
require_relative 'request_model.rb'
require_relative 'response_model.rb'


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

  def respond
    # Builds a response, sets next request, pushes it to the requests array, clears next request
    # and returns last response
    res = build_response
    begin
      next_request.response = ResponseModel.new(res.code,
                                                res.raw_headers,
                                                res.body,
                                                res.history)
    rescue StandardError => e
      raise "Request failed or unexpected response format. #{e} #{curl(1)}"
    end

    requests << next_request
    @next_request = nil
    last_response
  end

  attr_writer :default_headers
  def default_headers
    # Sets instance variable to be either what's given for default headers or an empty hash
    @default_headers ||= {}
  end

  attr_writer :default_params
  def default_params
    # Sets instance variable to be either what's given for default parameters or an empty hash
    @default_params ||= {}
  end

  def build_response
    # Executes a response using a gem (rest-client)
    RestClient::Request.execute(next_request.attrs)
  rescue RestClient::Exception => e
    e.response
  end

  def build_request(method, url, path)
    # Builds next request with a HTTP method, url and path
    next_request.method = method.to_s.downcase.to_sym
    next_request.url = File.join(url, path)
  end

  def requests
    # Sets instance variable to be either what's given for requests or an empty array
    @requests ||= []
  end

  def next_request
    # Sets instance variable to be either what's given or a new request model object with default headers and parameters
    @next_request ||= RequestModel.new(default_headers, default_params)
  end

  def last_request
    # Returns the last request in the requests array
    requests.last
  end

  def responses
    # Returns the response from each request in an array
    requests.map(&:response)
  end

  def last_response
    # Returns the response of the last request
    last_request.response
  end
end