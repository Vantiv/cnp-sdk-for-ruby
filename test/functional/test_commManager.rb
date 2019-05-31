require File.expand_path("../../../lib/CnpOnline",__FILE__)
require 'test/unit'

module CnpOnline
  class TestCommManager < Test::Unit::TestCase

    @@site1Url = "https://multisite1.com"
    @@site2Url = "https://multisite2.com"
    @@legacyUrl = "https://legacy.com"

    def test_instance_legacy
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = false
      _config["printMultiSiteDebug"] = true

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_false(_cmg.multiSite)
      assert_equal(@@legacyUrl, _cmg.legacyUrl)

      _config2 = Configuration.new.config
      _config2["url"] = "https://nowhere.com"
      _config2["multiSite"] = false
      _config2["printMultiSiteDebug"] = true
      _cmg2 = CommManager.instance(_config2)
      assert_equal(@@legacyUrl, _cmg2.legacyUrl) # should be same manager as previous
    end

    def test_instance_multi_site
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 4
      _config["maxHoursWithoutSwitch"] = 48

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(4, _cmg.multiSiteThreshold)
      assert_equal(2, _cmg.multiSiteUrls.length)

    end

    def test_instance_multi_site_no_urls
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_false(_cmg.multiSite)
    end

    def test_instance_multi_site_default_props
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteErrorThreshold"] = 102
      _config["maxHoursWithoutSwitch"] = 500

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(5, _cmg.multiSiteThreshold)
      assert_equal(48, _cmg.maxHoursWithoutSwitch)
    end

    def test_instance_multi_site_out_of_range
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
    end

    def test_find_url_legacy
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = false
      _config["printMultiSiteDebug"] = false

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_false(_cmg.multiSite)

      _requestTarget = _cmg.findUrl
      assert_equal(@@legacyUrl, _requestTarget.targetUrl)
    end

    def test_find_url_multi_site1
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 4
      _config["maxHoursWithoutSwitch"] = 48

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)

      _requestTarget = _cmg.findUrl
      assert_equal(_cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex), _requestTarget.targetUrl)
      assert_true(_requestTarget.targetUrl == @@site1Url || _requestTarget.targetUrl == @@site2Url)
    end

    def test_find_url_multi_site2
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = false
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 3
      _config["maxHoursWithoutSwitch"] = 48

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(3, _cmg.multiSiteThreshold)
      
      _requestTarget1 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex))
      _cmg.reportResult(_requestTarget1, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      _requestTarget2 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget2.targetUrl)
      _cmg.reportResult(_requestTarget2, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      _requestTarget3 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget3.targetUrl)
      _cmg.reportResult(_requestTarget3, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      assert_equal(3, _cmg.errorCount)

      _requestTarget4 = _cmg.findUrl
      assert_false(_requestTarget4.targetUrl == _requestTarget1.targetUrl)
    end

    def test_find_url_multi_site3
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = false
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 3
      _config["maxHoursWithoutSwitch"] = 48

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(3, _cmg.multiSiteThreshold)

      _requestTarget1 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex))
      _cmg.reportResult(_requestTarget1, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      _requestTarget2 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget2.targetUrl)
      _cmg.reportResult(_requestTarget2, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      _requestTarget3 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget3.targetUrl)
      _cmg.reportResult(_requestTarget3, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      assert_equal(3, _cmg.errorCount)

      _requestTarget4 = _cmg.findUrl
      assert_false(_requestTarget4.targetUrl == _requestTarget1.targetUrl)

      _requestTarget10 = _cmg.findUrl
      assert_equal(_cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex), _requestTarget10.targetUrl)
      _cmg.reportResult(_requestTarget10, _cmg.REQUEST_RESULT_RESPONSE_RECEIVED, 401)
      _requestTarget11 = _cmg.findUrl
      assert_equal(_requestTarget10.targetUrl, _requestTarget11.targetUrl)
      _cmg.reportResult(_requestTarget11, _cmg.REQUEST_RESULT_CONNECTION_FAILED, 0)
      _requestTarget12 = _cmg.findUrl
      assert_equal(_requestTarget11.targetUrl, _requestTarget12.targetUrl)
      _cmg.reportResult(_requestTarget12, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      assert_equal(_cmg.errorCount, 3)

      _requestTarget13 = _cmg.findUrl
      assert_false(_requestTarget13.targetUrl == _requestTarget11.targetUrl)
      assert_true(_requestTarget13.targetUrl == _requestTarget1.targetUrl)

    end

    def test_find_url_multi_site4
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = false
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 3
      _config["maxHoursWithoutSwitch"] = 0

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(3, _cmg.multiSiteThreshold)

      _requestTarget1 = _cmg.findUrl
      assert_equal(_cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex), _requestTarget1.targetUrl)
      _cmg.reportResult(_requestTarget1, _cmg.REQUEST_RESULT_RESPONSE_TIMEOUT, 0)
      _requestTarget2 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget2.targetUrl)
      _cmg.reportResult(_requestTarget2, _cmg.REQUEST_RESULT_RESPONSE_RECEIVED, 200)
      assert_equal(_cmg.errorCount, 0)

      _requestTarget3 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget3.targetUrl)
      _cmg.reportResult(_requestTarget3, _cmg.REQUEST_RESULT_RESPONSE_RECEIVED, 301)
      assert_equal(_cmg.errorCount, 0)

    end

    # test that url is switched when number of hours since last switch exceeds threshold
    def test_find_url_multi_site_max_hours
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = true
      _config["printMultiSiteDebug"] = true
      _config["multSiteUrl1"] = @@site1Url
      _config["multSiteUrl2"] = @@site2Url
      _config["multiSiteThreshold"] = 3
      _config["maxHoursWithoutSwitch"] = 4

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_true(_cmg.multiSite)
      assert_equal(3, _cmg.multiSiteThreshold)

      _requestTarget1 = _cmg.findUrl
      assert_equal(_cmg.multiSiteUrls.at(_cmg.currentMultiSiteUrlIndex), _requestTarget1.targetUrl)
      _cmg.reportResult(_requestTarget1, _cmg.REQUEST_RESULT_RESPONSE_RECEIVED, 200)
      _requestTarget2 = _cmg.findUrl
      assert_equal(_requestTarget1.targetUrl, _requestTarget2.targetUrl)
      _cmg.reportResult(_requestTarget2, _cmg.REQUEST_RESULT_RESPONSE_RECEIVED, 200)

      _cmg.lastSiteSwitchTime = _cmg.lastSiteSwitchTime - 2.16e+7 # hours in milliseconds

      _requestTarget3 = _cmg.findUrl
      assert_false(_requestTarget3.targetUrl == _requestTarget1.targetUrl)
    end

    def test_report_result_not_multi_site
      _config = Configuration.new.config
      _config["url"] = @@legacyUrl
      _config["multiSite"] = false
      _config["printMultiSiteDebug"] = true

      CommManager.reset
      _cmg = CommManager.instance(_config)

      assert_not_nil(_cmg)
      assert_false(_cmg.multiSite)
      assert_equal(_cmg.legacyUrl, @@legacyUrl)
      _requestTarget = RequestTarget.new("", 1)
      _cmg.reportResult(_requestTarget, 1, 0)

    end


    def to_boolean(str)
      str == 'true'
    end
  end
end

