require File.expand_path("../../../lib/CnpOnline",__FILE__) 
require 'test/unit'

#test Activate Transaction
module CnpOnline
  class TestOverride < Test::Unit::TestCase
     def test_override_withoutLocalAndEnv
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'orderId' =>'1001',
        'amount' =>'500',
        'orderSource' =>'ecommerce',
        'card'=>{
          'type'=>'GC',
          'number' =>'4100000000000001',
          'expDate' =>'1210'
        }
      }
      response= CnpOnlineRequest.new.activate(hash)
      assert_equal('Default Report Group', response.activateResponse.reportGroup)
    end
    
    def test_override_withoutLocal
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'orderId' =>'1001',
        'amount' =>'500',
        'orderSource' =>'ecommerce',
        'card'=>{
          'type'=>'GC',
          'number' =>'4100000000000001',
          'expDate' =>'1210'
        }
      }
      ENV['cnp_default_report_group']='380'
      response= CnpOnlineRequest.new.activate(hash)
      assert_equal('380', response.activateResponse.reportGroup)
      ENV['cnp_default_report_group']=nil
     
    end
    def test_override
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' =>'1001',
        'amount' =>'500',
        'orderSource' =>'ecommerce',
        'card'=>{
          'type'=>'GC',
          'number' =>'4100000000000001',
          'expDate' =>'1210'
        }
      }
      ENV['cnp_default_report_group']='380'
      response= CnpOnlineRequest.new.activate(hash)
      assert_equal('Planets', response.activateResponse.reportGroup)
       ENV['cnp_default_report_group']=nil

    end
    
  end
end