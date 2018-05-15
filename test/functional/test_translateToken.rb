=begin
Copyright (c) 2018 Vantiv eCommerce

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
  class TestTranslateToken < Test::Unit::TestCase
    def test_token_happy
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',

          'orderId'=>'5656',
          'token'=>'444'
      }
      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('803', response.translateToLowValueTokenResponse.response)

    end
    def test_ttlvt
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('0', response.response)

    end

    def test_ttlvt_fields_out_of_order
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'orderId' => 'test',
          'token' => '1111222233334444',
          'reportGroup' =>'Planets'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('0', response.response)

    end

    def test_ttlvt_invalid_field
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444',
          'testField' => 'ShouldNotCauseError'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('0', response.response)

    end

    def test_ttlvt_no_orderId
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'token' => '1111222233334444'
      }
      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('0', response.response)
    end

    def test_ttlvt_response_orderId
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444'
      }
      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('test', response.translateToLowValueTokenResponse.orderId)
    end

    def test_ttlvt_no_token
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.translate_to_low_value_token_request(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_ttlvt_too_long_orderId
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'this string contains more than twenty five characters',
          'token' => '1111222233334444'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.translate_to_low_value_token_request(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_ttlvt_response_valid
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('803', response.translateToLowValueTokenResponse.response)
      assert_equal('Valid Token', response.translateToLowValueTokenResponse.response)
    end

    def test_ttlvt_response_not_authorized
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444821'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('821', response.translateToLowValueTokenResponse.response)
      assert_equal('Merchant is not authorized for tokens', response.translateToLowValueTokenResponse.response)

    end

    def test_ttlvt_response_not_found
      hash = {
          'merchantId' => '101',
          'version'=>'12.3',
          'id' => 'testId',
          'reportGroup'=>'Planets',
          'orderId' => 'test',
          'token' => '1111222233334444822'
      }

      response= CnpOnlineRequest.new.translate_to_low_value_token_request(hash)

      assert_equal('822', response.translateToLowValueTokenResponse.response)
      assert_equal('Token was not found', response.translateToLowValueTokenResponse.response)

    end

  end


end