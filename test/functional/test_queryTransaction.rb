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
  class TestqueryTransaction < Test::Unit::TestCase
    def test_queryTransaction
     hash = {
       'merchantId' => '101',
       'id' => 'test',
       'version'=>'10.0',
       'reportGroup'=>'Some RG',
       'customerId' => '038945',
       'origId' => '834262',
       'origActionType' => 'A',
       'transactionId'=>'123456',
       'orderId'=>'65347567',
       #'origAccountNumber' => '4000000000000001'      
       }
       response= CnpOnlineRequest.new.query_Transaction(hash)
       assert_equal('150', response.queryTransactionResponse.response)
    end

    def test_queryTransaction_noOrigId_noOrigActionType
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'10.0',
          'reportGroup'=>'Some RG',
          'customerId' => '038945',
          'transactionId'=>'123456',
          'orderId'=>'65347567',
          #'origAccountNumber' => '4000000000000001'
      }
      response= CnpOnlineRequest.new.query_Transaction(hash)
      assert_equal('150', response.queryTransactionResponse.response)
    end

    def test_queryTransaction_withShowStatusOnly
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'10.0',
          'reportGroup'=>'Some RG',
          'customerId' => '038945',
          'origId' => '834262',
          'origActionType' => 'A',
          'transactionId'=>'123456',
          'orderId'=>'65347567',
          'showStatusOnly' => 'Y'
          #'origAccountNumber' => '4000000000000001'
      }
      response= CnpOnlineRequest.new.query_Transaction(hash)
      assert_equal('150', response.queryTransactionResponse.response)
    end

    def test_queryTransaction_invalidShowStatusOnly
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'10.0',
          'reportGroup'=>'Some RG',
          'customerId' => '038945',
          'origId' => '834262',
          'origActionType' => 'A',
          'transactionId'=>'123456',
          'orderId'=>'65347567',
          'showStatusOnly' => 'A'
          #'origAccountNumber' => '4000000000000001'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.query_Transaction(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
      
    def test_queryTransaction_valid_enum
     hash = {
       'merchantId' => '101',
       'id' => 'test',
       'version'=>'10.0',
       'reportGroup'=>'Some RG',
       'customerId' => '038945',
       'origId' => '834262',
       'origActionType' => '',
       'transactionId'=>'123456',
       'orderId'=>'65347567',
       #'origAccountNumber' => '4000000000000001'      
      }  
      response= CnpOnlineRequest.new.query_Transaction(hash)
      assert('000', response.queryTransactionResponse.response)                
    end
    
    def test_queryTransaction_invalid_values
     hash = {
       'merchantId' => '101',
       'id' => 'test',
       'version'=>'10.0',
       'reportGroup'=>'Some RG',
       'customerId' => '038945',
       'origId' => '834262',
       'origActionType' => 'AAA',
       'transactionId'=>'123456',
       'orderId'=>'65347567',
       #'origAccountNumber' => '4000000000000001'      
     }
     #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.query_Transaction(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)  
    end
     
    def test_queryTransaction_unavailable_response
     hash = {
       'merchantId' => '101',
       'id' => 'test',
       'version'=>'10.0',
       'reportGroup'=>'Some RG',
       'customerId' => '038945',
       'origId' => 'aaa',
       'origActionType' => 'A',
       'transactionId'=>'123456',
       'orderId'=>'65347567',
       #'origAccountNumber' => '4000000000000001' 
       } 
       response= CnpOnlineRequest.new.query_Transaction(hash)
       assert_equal('152', response.queryTransactionUnavailableResponse.response)
    end
  end
end