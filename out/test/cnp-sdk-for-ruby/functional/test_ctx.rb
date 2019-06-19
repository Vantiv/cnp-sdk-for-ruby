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
class TestCtx < Test::Unit::TestCase


  def test_simple_vendor_debit_online
    hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'fundingSubmerchantId' => 'hello',
        'vendorName' => 'me',
        'fundsTransferId' => '1234567',
        'amount'=>'106',
        'accountInfo' => {
            "accType" => "Savings",
            "accNum" => "123",
            "routingNum" => "888888888",
            "ccdPaymentInformation" => "asbdccc"
        }}

    response = CnpOnlineRequest.new.vendor_debit(hash)
    assert_equal 'Valid Format', response.message
  end

  def test_simple_vendor_credit_online
    hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'fundingSubmerchantId' => 'hello',
        'vendorName' => 'me',
        'fundsTransferId' => '1234567',
        'amount'=>'106',
        'accountInfo' => {
            "accType" => "Savings",
            "accNum" => "123",
            "routingNum" => "888888888",
            "ccdPaymentInformation" => "asbdccc"
        }}

    response = CnpOnlineRequest.new.vendor_credit(hash)
    assert_equal 'Valid Format', response.message
  end

  def test_simple_submerchant_debit_online
    hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'fundingSubmerchantId' => 'hello',
        'submerchantName' => 'me',
        'fundsTransferId' => '1234567',
        'amount'=>'106',
        'accountInfo' => {
            "accType" => "Savings",
            "accNum" => "123",
            "routingNum" => "888888888",
            "ccdPaymentInformation" => "asbdccc"
        },
        'customerIdentifier' => 'yessum'
    }

    response = CnpOnlineRequest.new.submerchant_debit(hash)
    assert_equal 'Valid Format', response.message
  end

  def test_simple_subermchant_credit_online
    hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'fundingSubmerchantId' => 'hello',
        'submerchantName' => 'me',
        'fundsTransferId' => '1234567',
        'amount'=>'106',
        'accountInfo' => {
            "accType" => "Savings",
            "accNum" => "123",
            "routingNum" => "888888888",
            "ccdPaymentInformation" => "asbdccc"
        },
        'customerIdentifier' => 'yessum'
    }

    response = CnpOnlineRequest.new.submerchant_credit(hash)
    assert_equal 'Valid Format', response.message
  end

  def test_hello
    Net::SFTP.start("nufloprftp01.litle.com", "sdkv12txn", :password => "f4Vt2T4A", :non_interactive => true)
  end
end
end