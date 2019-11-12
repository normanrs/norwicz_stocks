class RequestModel
  attr_accessor :method
  attr_accessor :url
  attr_accessor :headers
  attr_accessor :params
  attr_accessor :obj
  attr_accessor :response

  def initialize(headers = {}, params = {})
    @method = nil
    @url = nil
    @headers = headers
    @params = params
    @obj = nil
    @response = nil
  end

  def payload
    if obj.class == Hash
      obj ? obj.to_json : obj
    else
      obj
    end
  end

  def attrs
    {
      method:  method,
      url:     url,
      payload: payload,
      headers: headers.merge(params: params)
    }
  end
end
