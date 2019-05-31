require_relative 'RequestTarget.rb'

module CnpOnline
  class CommManager
    attr_reader :REQUEST_RESULT_RESPONSE_RECEIVED, :REQUEST_RESULT_CONNECTION_FAILED, :REQUEST_RESULT_RESPONSE_TIMEOUT,
                :multiSite, :legacyUrl, :multiSiteThreshold, :multiSiteUrls, :maxHoursWithoutSwitch, :currentMultiSiteUrlIndex,
                :errorCount, :lastSiteSwitchTime
    attr_writer :lastSiteSwitchTime

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
      @multiSite = @config_hash['multiSite'] != nil ? @config_hash['multiSite'] : false
      @legacyUrl = @config_hash['url']
      @multiSiteUrls = Array.new
      @errorCount = 0
      @currentMultiSiteUrlIndex = 0
      @multiSiteThreshold = 5
      @lastSiteSwitchTime = 0
      # @maxHoursWithoutSwitch = @config_hash['maxsHoursWithoutSwitch']
      @maxHoursWithoutSwitch = 48
      @printDebug = @config_hash['printMultiSiteDebug'] #get false as default


      if (to_boolean(@multiSite))

        for i in 1..2 do
          @siteUrl = @config_hash["multSiteUrl" + i.to_s]
          if (@siteUrl == '' || @siteUrl == nil)
            break
          end
          @multiSiteUrls << @siteUrl
        end

          if (@multiSiteUrls.length == 0)
            @multiSite = false
          else
            @multiSiteUrls.shuffle
            @currentMultiSiteUrlIndex = 0
            @errorCount = 0

            _threshold = @config_hash['multiSiteThreshold']
            if (_threshold != nil)
              if (_threshold > 0 && _threshold < 100)
                @multiSiteThreshold = _threshold
              end
            end

            _maxHours = @config_hash['maxsHoursWithoutSwitch']
            if (_maxHours != nil)
              if (_maxHours >= 0 && _maxHours < 300)
                @maxHoursWithoutSwitch = _maxHours
              end
            end

            @lastSiteSwitchTime = Time.now.to_i * 1000
          end
        # end
      end
    end


    def self.instance(config)
      if (@@manager == nil)
        @@manager = CommManager.new(config)
      end
      return @@manager
    end

    def self.reset
      @@manager = nil
    end

    def findUrl()

      _url = @legacyUrl
      if (to_boolean(@multiSite))
        _switchSite = false
        _switchReason = ''
        _currentUrl = @multiSiteUrls.at(@currentMultiSiteUrlIndex)

        if (@errorCount < @multiSiteThreshold)
          if (@maxHoursWithoutSwitch > 0)
            _diffSinceSwitch = ((Time.now.to_i * 1000) - @lastSiteSwitchTime) / 3600
            if (_diffSinceSwitch > @maxHoursWithoutSwitch)
              _switchReason = " more than " + @maxHoursWithoutSwitch.to_s + " hours since last switch"
              _switchSite = true
            end
          end
        else
        _switchReason = " consecutive error count has reach threshold of " + @multiSiteThreshold.to_s
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
      if (target.requestTime < @lastSiteSwitchTime || !@multiSite)
        return
      end

      case(result)
      when @REQUEST_RESULT_RESPONSE_RECEIVED
        if (statusCode == 200)
          @errorCount = 0
        elsif (statusCode >= 400)
          @errorCount += 1
        end
      when @REQUEST_RESULT_CONNECTION_FAILED
        @errorCount += 1
      when @REQUEST_RESULT_RESPONSE_TIMEOUT
        @errorCount += 1
      end
    end

    private
    def to_boolean(str)
      if str.instance_of? String
        str == 'true'
      else
        return str
      end
    end
  end
end