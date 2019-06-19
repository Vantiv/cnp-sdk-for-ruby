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
  class TestAuthReversal < Test::Unit::TestCase
    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'cnpTxnId'=>'12345678000',
        'NonexistentField'=>'none',
        'payPalNotes'=>'Notes',
        'amount'=>'106',
        'reportGroup'=>'Planets',
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<cnpTxnId>12345678000<\/cnpTxnId>.*/m), is_a(Hash))
      CnpOnlineRequest.new.auth_reversal(hash)
    end  

    def test_logged_in_user
      hash = {
       	'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
        'version'=>'8.8',
        'cnpTxnId'=>'12345678000',
		    'reportGroup'=>'Planets',
		    'amount'=>'5000',
		    'loggedInUser'=>'gdake'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      CnpOnlineRequest.new.auth_reversal(hash)
    end  
    
    def test_surcharge_amount
      hash = {
        'cnpTxnId' => '3',
        'amount' => '2',
        'surchargeAmount' => '1',
        'payPalNotes' => 'note',
        'reportGroup' => 'Planets'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><surchargeAmount>1<\/surchargeAmount><payPalNotes>note<\/payPalNotes>.*/m), is_a(Hash))
      CnpOnlineRequest.new.auth_reversal(hash)
    end
    
    def test_surcharge_amount_optional
      hash = {
        'cnpTxnId' => '3',
        'amount' => '2',
        'payPalNotes' => 'note',
        'reportGroup' => 'Planets'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><payPalNotes>note<\/payPalNotes>.*/m), is_a(Hash))
      CnpOnlineRequest.new.auth_reversal(hash)
    end
  end
end
