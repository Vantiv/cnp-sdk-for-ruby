module CnpOnline
  class RequestTarget
    attr_reader :targetUrl, :urlIndex, :requestTime
    def initialize(url, index)
      @targetUrl = url
      @urlIndex = index
      @requestTime = Time.now.to_i * 1000
    end
  end
end