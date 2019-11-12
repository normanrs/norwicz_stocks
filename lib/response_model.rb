class ResponseModel
  attr_reader :status
  attr_reader :headers
  attr_reader :payload
  attr_reader :history

  def initialize(status, headers, payload, history)
    @status = status
    @headers = headers
    @payload = payload
    @history = history
  end

  def attrs
    {
      status:  status,
      headers: headers,
      payload: payload
    }
  end

  def obj
    @obj ||= payload ? JSON.parse(payload) : nil
  end

  def value_at(path)
    path.inject(obj) do |curr, key|
      if key == ''
        curr
      else
        curr[key]
      end
    end
  end
end
