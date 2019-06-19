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
require 'mocha/setup'

module CnpOnline
  class Test_echeckCredit < Test::Unit::TestCase
    def test_echeck_credit_with_both
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'cnpTxnId'=>'123456',
        'echeckToken' => {'accType'=>'Checking','cnpToken'=>'1234565789012','routingNum'=>'123456789','checkNum'=>'123455'},
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.echeck_credit(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_logged_in_user
      hash = {
        'loggedInUser' => 'gdake',
        'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'cnpTxnId'=>'123456',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      CnpOnlineRequest.new.echeck_credit(hash)
    end

    def test_echeck_credit_with_orderId_secondary_amount
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'secondaryAmount' => '1',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><secondaryAmount>1<\/secondaryAmount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      CnpOnlineRequest.new.echeck_credit(hash)
    end
    
    def test_echeck_credit_with_txnId_secondaryAmount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'cnpTxnId'=>'123456789101112',
        'amount'=>'12',
        'secondaryAmount'=>'1'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<cnpTxnId>123456789101112<\/cnpTxnId>.*?<amount>12<\/amount><secondaryAmount>1<\/secondaryAmount>.*/m), is_a(Hash))
            CnpOnlineRequest.new.echeck_credit(hash)
    end
    
    def test_echeck_credit_with_customIdentifier
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'123',
        'secondaryAmount'=>'1',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455','ccdPaymentInformation'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'cnp.com'},
        'merchantData'=>{'campaign'=>'camping'},
        'customIdentifier' =>'identifier',
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<customIdentifier>identifier<\/customIdentifier>.*/m), is_a(Hash))
            CnpOnlineRequest.new.echeck_credit(hash)
    end

  end
end
