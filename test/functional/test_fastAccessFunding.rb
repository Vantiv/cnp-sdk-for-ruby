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
  class TestFastAccessFunding < Test::Unit::TestCase
    def test_faf
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'amount'=>'106',
          'fundingSubmerchantId'=>'this is a merchant id',
          'submerchantName'=>'this is a very long string',
          'fundsTransferId'=>'0123456789abcdef',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      response= CnpOnlineRequest.new.fast_access_funding(hash)

      assert_equal('0', response.response)

    end

    def test_faf_fields_out_of_order
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'amount'=>'106',
          'fundingSubmerchantId'=>'this is a merchant id',
          'submerchantName'=>'this is a very long string',
          'fundsTransferId'=>'0123456789abcdef',
          'reportGroup'=>'Planets',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      response= CnpOnlineRequest.new.fast_access_funding(hash)

      assert_equal('0', response.response)

    end

    def test_faf_invalid_field
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'amount'=>'106',
          'fundingSubmerchantId'=>'this is a merchant id',
          'submerchantName'=>'this is a very long string',
          'fundsTransferId'=>'0123456789abcdef',
          'card'=>{
              'NOexistantField' => 'ShouldNotCauseError',
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      response= CnpOnlineRequest.new.fast_access_funding(hash)

      assert_equal('0', response.response)

    end

    def test_faf_no_fundingSubmerchantId
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'amount'=>'106',
          'submerchantName'=>'this is a very long string',
          'fundsTransferId'=>'0123456789abcdef',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.fast_access_funding(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_faf_no_submerchantName
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'amount'=>'106',
          'fundingSubmerchantId'=>'this is a merchant id',
          'fundsTransferId'=>'0123456789abcdef',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.fast_access_funding(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_faf_no_fundsTransferId
      hash = {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'amount'=>'106',
          'fundingSubmerchantId'=>'this is a merchant id',
          'submerchantName'=>'this is a very long string',
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000001',
              'expDate' =>'1210'
          }}
      #Get exceptions
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.fast_access_funding(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

  end

end