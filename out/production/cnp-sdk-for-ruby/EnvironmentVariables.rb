module CnpOnline
  class EnvironmentVariables
    def initialize
      # load configuration data
      @user = ''
      @password = ''
      @currency_merchant_map = ''
      @default_report_group = 'Default Report Group'
      @url = ''
      @proxy_addr = nil
      @proxy_port = nil
      @sftp_username = ''
      @sftp_password = ''
      @sftp_url = ''
      @fast_url = ''
      @fast_port = ''
      @printxml = false
      @timeout = 65
      @deleteBatchFiles = false
      @useEncryption = false
      @vantivPublicKeyID = ''
      @passphrase = ''
      @multiSiteUrl1 = ''
      @multiSiteUrl2 = ''
      @multiSite = false
      @printMultiSiteDebug = false
      @multiSiteErrorThreshold = 5
      @maxsHoursWithoutSwitch = 48


    end
  end
end
