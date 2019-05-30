require_relative 'RequestTarget.rb'

module CnpOnline
  class CommManager
    attr_reader :REQUEST_RESULT_RESPONSE_RECEIVED, :REQUEST_RESULT_CONNECTION_FAILED, :REQUEST_RESULT_RESPONSE_TIMEOUT

    @@manager = nil

    def manager
      @@manager
    end

    def self.manager
      @@manager
    end


    def initialize(config)
      @REQUEST_RESULT_RESPONSE_RECEIVED = 1
      @REQUEST_RESULT_CONNECTION_FAILED = 2
      @REQUEST_RESULT_RESPONSE_TIMEOUT = 3

      @config_hash = config
      @doMultiSite = @config_hash['doMultiSite'] #get false as default
      @legacyUrl = @config_hash['url']
      @multiSiteUrls = Array.new
      @errorCount = 0
      @currentMultiSiteUrlIndex = 0
      @multiSiteThreshold = @config_hash['multiSiteThreshold']
      @lastSiteSwitchTime = 0
      @maxHoursWithoutSwitch = @config_hash['maxsHoursWithoutSwitch']
      @printDebug = @config_hash['printMultiSiteDebug'] #get false as default



      if (to_boolean(@doMultiSite))

        for i in 1..2 do
          @siteUrl = @config_hash["multSiteUrl" + i]
          if (@siteUrl == '')
            break
          end

          @multiSiteUrls << @siteUrl

          if (@multiSiteUrls.length)
            @doMultiSite = false
          else
            @multiSiteUrls.shuffle
            @currentMultiSiteUrlIndex = 0
            @errorCount = 0

            if (@multiSiteThreshold > 100 || @multiSiteThreshold < 0)
              #throw an error
            end

            if (@maxHoursWithoutSwitch > 300 || @maxHoursWithoutSwitch > 0)
              #throw an error
            end
            @lastSiteSwitchTime = Time.now.to_i
          end
        end
      end
    end


    def self.instance(config)
      if (@@manager == nil)
        @@manager = CommManager.new(config)
      end
      return @@manager
    end

    def self.reset()
      @@manager = nil
    end

    def findUrl()

      _url = @legacyUrl
      if (to_boolean(@doMultiSite))
        _switchSite = false
        _switchReason = ''
        _currentUrl = @multiSiteUrls.at(@currentMultiSiteUrlIndex)

        if (@errorCount < @multiSiteThreshold)
          if (@maxHoursWithoutSwitch > 0)
            _diffSinceSwitch = (Time.now.to_i - @lastSiteSwitchTime) / 3600000
            if (_diffSinceSwitch > @maxHoursWithoutSwitch)
              _switchReason = " more than " + @maxHoursWithoutSwitch + " hours since last switch"
              _switchSite = true
            end
          end
        else
        _switchReason = " consecutive error count has reach threshold of " + @multiSiteThreshold
        _switchSite = true
        end

        if (_switchSite)
        @currentMultiSiteUrlIndex += 1
          if (@currentMultiSiteUrlIndex >= @multiSiteUrls.length)
            @currentMultiSiteUrlIndex = 0
          end

          _url = @multiSiteUrls.at(@currentMultiSiteUrlIndex)
          @errorCount = 0

          if (@printDebug)
           #print debug here
          end
        else
          _url = _currentUrl
       end

        if (@printDebug)
         #print some debug
       end
      end

      return RequestTarget.new(_url, @currentMultiSiteUrlIndex)
    end

    def reportResult(target, result, statusCode)
      if (target.requestTime < @lastSiteSwitchTime || !@doMultiSite)
        return
      end

      case(result)
      when @@REQUEST_RESULT_RESPONSE_RECEIVED
        if (statusCode == 200)
          @errorCount = 0
        elsif (statusCode >= 400)
          @errorCount += 1
        end
      when @@REQUEST_RESULT_CONNECTION_FAILED
        @errorCount += 1
      when @@REQUEST_RESULT_RESPONSE_TIMEOUT
        @errorCount += 1
      end
    end

    def to_boolean(str)
      str == 'true'
    end
  end
end