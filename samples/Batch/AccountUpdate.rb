require_relative '../../lib/CnpOnline'
accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'1234',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}

saleHash = {
        'reportGroup'=>'Planets',
        'id' => '006',
        'orderId'=>'12344',
        'amount'=>'6000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
       
authReversalHash = {
        'merchantId' => '101',
         'id' => '006',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'cnpTxnId'=>'12345678000',
        'amount'=>'106',
        'payPalNotes'=>'Notes'
      }
path = Dir.pwd
 
request = CnpOnline::CnpRequest.new({'sessionId'=>'8675309'})
  
request.create_new_cnp_request(path)
puts "Created new CnpRequest at location: " + path
start = Time::now
#create five batches, each with 10 sales

  batch = CnpOnline::CnpBatchRequest.new
  batch.create_new_batch(path)
 
  #add the same sale ten times

   batch.account_update(accountUpdateHash)
 
  #close the batch, indicating we plan to add no more transactions
  batch.close_batch()
  #add the batch to the CnpRequest
  request.commit_batch(batch)

  
  request.finish_request
puts "Generated final XML markup of the CnpRequest"
 
#send the batch files at the given directory over sFTP
request.send_to_cnp
puts "Dropped off the XML of the CnpRequest over FTP"
#grab the expected number of responses from the sFTP server and save them to the given path
request.get_responses_from_server()
puts "Received the CnpRequest responses from the server"     

