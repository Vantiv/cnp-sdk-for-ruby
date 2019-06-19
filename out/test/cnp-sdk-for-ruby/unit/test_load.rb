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
  class TestLoad < Test::Unit::TestCase

    def test_simple
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'amount'  => '500',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'GC',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }

      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<load reportGroup="Planets"><orderId>11<\/orderId><amount>500<\/amount><orderSource>ecommerce<\/orderSource><card><type>GC<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/load>.*/m), is_a(Hash))
      CnpOnlineRequest.new.load_request(hash)
    end

   end

end
