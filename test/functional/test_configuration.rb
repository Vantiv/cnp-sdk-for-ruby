=begin
Copyright (c) 2017 Vantiv eCommerce
Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
require File.expand_path("../../../lib/CnpOnline",__FILE__) 
require 'test/unit'


module CnpOnline
  class TestConfiguration < Test::Unit::TestCase
    #the flag is to judge the data in config file exist or not
    @@flag=false
    def test_configuration_with_file
      @config_hash = Configuration.new.config
      @config_hash.each {|key,value| checkAttributes(key,@config_hash)}
      assert_equal(false, @@flag)
    end

    def checkAttributes(key,datas)
      if (datas[key].nil?)
      @@flag=true
      end
    end

    def test_configuration_mix_file_env
      #check the env variable override
      ENV['cnp_timeout']='80'
      @config_hash = Configuration.new.config
      assert_equal('80',@config_hash['timeout'])
      ENV['cnp_timeout']=nil
    end



    def test_configuration_without_file
      #set up Env variable
      ENV['cnp_user']='isola'
      ENV['cnp_password']='vinicius'
      ENV['cnp_currency_merchant_map']='0180'
      ENV['cnp_url']='basketball@gmail.com'
      ENV['cnp_proxy_addr']='iwp1.lowell.cnp.com'
      ENV['cnp_proxy_port']='8080'
      ENV['cnp_sftp_username']='sdkFire'
      ENV['cnp_sftp_password']='fire is comming'
      ENV['cnp_fast_url']='prelive.cnp.com'
      ENV['cnp_fast_port']='15000'
      @config_hash = Configuration.new.config
      assert_equal('isola',@config_hash['user'])
      assert_equal('vinicius',@config_hash['password'])
      assert_equal('0180',@config_hash['currency_merchant_map'])
      assert_equal('basketball@gmail.com',@config_hash['url'])
      assert_equal('iwp1.lowell.cnp.com',@config_hash['proxy_addr'])
      assert_equal('8080',@config_hash['proxy_port'])
      assert_equal('sdkFire',@config_hash['sftp_username'])
      assert_equal('fire is comming',@config_hash['sftp_password'])
      assert_equal('prelive.cnp.com',@config_hash['fast_url'])
      assert_equal('15000',@config_hash['fast_port'])
      ENV['cnp_user']=nil
      ENV['cnp_password']=nil
      ENV['cnp_currency_merchant_map']=nil
      ENV['cnp_url']=nil
      ENV['cnp_proxy_addr']=nil
      ENV['cnp_proxy_port']=nil
      ENV['cnp_sftp_username']=nil
      ENV['cnp_sftp_password']=nil
      ENV['cnp_fast_url']=nil
      ENV['cnp_fast_port']=nil
    end

  end
end