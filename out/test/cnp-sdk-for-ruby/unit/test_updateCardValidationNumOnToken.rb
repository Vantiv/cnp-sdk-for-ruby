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
  class TestUpdateCardValidationNumOnToken < Test::Unit::TestCase
    def test_simple
      hash = {
        'orderId'=>'12344',
        'cnpToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<orderId>1.*<cnpToken>1233456789101112.*<cardValidationNum>123.*/m), is_a(Hash))
      CnpOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
    
    def test_order_id_is_optional
      hash = {
        'cnpToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*<cnpToken>1233456789101112.*<cardValidationNum>123.*/m), is_a(Hash))
      CnpOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
    
    def test_cnp_token_is_required
      hash = {
        'orderId'=>'12344',
        'cardValidationNum'=>'123'
      }
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.update_card_validation_num_on_token(hash)}
      assert_match /If updateCardValidationNumOnToken is specified, it must have a cnpToken/, exception.message
    end
    
    def test_card_validation_num_is_required
      hash = {
        'orderId'=>'12344',
        'cnpToken'=>'1233456789101112'
      }
      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.update_card_validation_num_on_token(hash)}
      assert_match /If updateCardValidationNumOnToken is specified, it must have a cardValidationNum/, exception.message
    end

    def test_logged_in_user
      hash = {
      	'loggedInUser' => 'gdake',
      	'merchantSdk' => 'Ruby;8.14.0',
        'orderId'=>'12344',
        'cnpToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      CnpOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
  end

end