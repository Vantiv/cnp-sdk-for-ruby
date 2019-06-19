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
require 'fileutils'

#test Authorization Transaction
module CnpOnline
  class TestBatch < Test::Unit::TestCase
  
    def setup
      dir = '/tmp/cnp-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir
    end
  
    def test_batch_file_creation
      dir = '/tmp'
      
      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')
      
      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      
      assert_equal 4,entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
    end
    
    def test_batch_file_creation_account_update
      dir = '/tmp'
      
      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')
      
      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      
      assert_equal 4,entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
      
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      batch.account_update(accountUpdateHash)
      
      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      assert_equal entries.length, 6
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/
      assert_not_nil entries[4] =~ /batch_\d+\z/
      assert_not_nil entries[5] =~ /batch_\d+_txns\z/ 
    end
    
    def test_batch_file_creation_on_file
      dir = '/tmp'
      
      File.open(dir + '/cnp-sdk-for-ruby-test/test_batch_file_creation_on_file', 'a+') do |file|
        file.puts("")
      end
      
      assert_raise ArgumentError do
        batch = CnpBatchRequest.new
        batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test/test_batch_file_creation_on_file')
      end
    end
    
    def test_batch_file_rename_and_remove
      dir = '/tmp'

      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')
      assert_equal Dir.entries(dir+'/cnp-sdk-for-ruby-test').size, 4
      batch.close_batch
      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      assert_equal entries.size, 3
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
    end
    
    def test_batch_file_create_new_dir
      dir = '/tmp'
      batch = CnpBatchRequest.new
      assert !File.directory?(dir + '/cnp-sdk-for-ruby-test/test_batch_file_create_new_dir')
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test/test_batch_file_create_new_dir')
      assert File.directory?(dir + '/cnp-sdk-for-ruby-test/test_batch_file_create_new_dir')
    end
    
    def test_batch_open_existing
      dir = '/tmp'
      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')
      
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'cnpTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      
      batch.sale(hash)

      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      entries.sort!
      
      batch2 = CnpBatchRequest.new
      batch2.open_existing_batch(dir + '/cnp-sdk-for-ruby-test/' + entries[2])
      assert_equal batch.get_counts_and_amounts, batch2.get_counts_and_amounts
    end
    
    def test_batch_open_existing_closed
      dir = '/tmp'
      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')
      batch.close_batch

      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      entries.sort!
      
      batch2 = CnpBatchRequest.new
      assert_raise ArgumentError do
        batch2.open_existing_batch(dir + '/cnp-sdk-for-ruby-test/' + entries[2])  
      end
    end

    def test_ctx_all
      dir = '/tmp'

      request = CnpRequest.new()
      request.create_new_cnp_request(dir + '/cnp-sdk-for-ruby-test')

      batch = CnpBatchRequest.new
      batch.create_new_batch(dir + '/cnp-sdk-for-ruby-test')

      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      entries.sort!

      echeck = {
          'accNum' => '1092969901',
          'accType' => 'Corporate',
          'routingNum' => '011075150',
          'checkNum' => '123455'
      }

      vCredit = {
          'reportGroup' => 'vendorCredit',
          'id' => '111',
          'fundingSubmerchantId' => 'vendorCredit',
          'vendorName' => 'Vendor101',
          'fundsTransferId' => '1001',
          'amount' => '500',
          'accountInfo' => echeck
      }
      batch.vendor_credit(vCredit)

      vDebit = {
          'reportGroup' => 'vendorDebit',
          'id' => '111',
          'fundingSubmerchantId' => 'vendorDebit',
          'vendorName' => 'Vendor101',
          'fundsTransferId' => '1001',
          'amount' => '500',
          'accountInfo' => echeck
      }
      batch.vendor_debit(vDebit)
      submerchantCreditCtx = {
          'reportGroup' => 'submerchantCredit',
          'id' => '111',
          'fundingSubmerchantId' => 'submerchantCredit',
          'submerchantName' => 'Vendor101',
          'fundsTransferId' => '1001',
          'amount' => '500',
          'accountInfo' => echeck
      }
      batch.submerchant_credit(submerchantCreditCtx)
      submerchantDebitCtx = {
          'reportGroup' => 'submerchantDebit',
          'id' => '111',
          'fundingSubmerchantId' => 'submerchantDebit',
          'submerchantName' => 'Vendor101',
          'fundsTransferId' => '1001',
          'amount' => '500',
          'accountInfo' => echeck
      }
      batch.submerchant_debit(submerchantDebitCtx)
      batch.close_batch

      request.commit_batch(batch)
      request.finish_request
      entries = Dir.entries(dir + '/cnp-sdk-for-ruby-test')
      entries.sort!
      print batch.get_counts_and_amounts
      print "\n"
      transactionCount = batch.get_num_transactions
      print batch.get_num_transactions
      print "\n"
      print transactionCount
      #send the batch files at the given directory over sFTP
      count = 1
      begin
        # request.send_to_cnp_stream
        request.send_to_cnp
      rescue
        if (count < 3) then
          count = count + 1
          retry
        else
          raise
        end
      end

      count_of_responses = 0
      request.get_responses_from_server
      request.process_responses({:transaction_listener => CnpOnline::DefaultCnpListener.new do |transaction|
        count_of_responses = count_of_responses + 1
      end})

      print "count of responses"
      print count_of_responses

      assert_equal(transactionCount, count_of_responses)
    end


  end
end 