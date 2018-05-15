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
  class TestCredit < Test::Unit::TestCase
    def test_simple_credit_with_card
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_simple_credit_with_paypal
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'orderId'=>'123456',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'payerId'=>'1234',
        'transactionId'=>'1234',
        }}
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_simple_credit_with_secondaryAmount
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'secondaryAmount'=>'50',
        'orderId'=>'123456',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'payerId'=>'1234',
        'transactionId'=>'1234',
        }}
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_credit_with_TxnID_secondaryAmount
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'secondaryAmount'=>'50',
        'cnpTxnId'=>'123456'
      }
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'orderSource'=>'ecommerce',
        'amount'=>'106'
      }
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'NOexistantField' => 'ShouldNotCauseError',
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_pay_pal_notes
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'payPalNotes'=>'Hello',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_credit_with_mpos
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'mpos'=>
		{
		'ksn'=>'ksnString',
		'formatId'=>'30',
		'encryptedTrack'=>'encryptedTrackString',
		'track1Status'=>'0',
		'track2Status'=>'0'
		}
      }
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_simple_credit_with_pin
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'secondaryAmount'=>'20',
        'cnpTxnId'=>'123456000',
        'pin'=>'1234'
        }
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
      assert_equal('000', response.creditResponse.response)
    end

    def test_simple_credit_with_lodging_info
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          },
          'lodgingInfo' => {
          'hotelFolioNumber ' => 'testFolio',
          'duration' => '111',
          'customerServicePhone' => 'testPhone1',
          'programCode' => 'LODGING',
          'roomRate' => '112233445566',
          'numAdults' => '11',
          'propertyLocalPhone' => 'testPhone2',
          'fireSafetyIndicator' => 'true',
          'lodgingCharge' => {'name' => 'RESTAURANT'}
          }
      }
      response= CnpOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
   
  end
end
