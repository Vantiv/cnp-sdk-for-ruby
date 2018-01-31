require_relative '../../lib/CnpOnline'
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
      
updateCardHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'cnpToken'=>'1233456789103801',
        'cardValidationNum'=>'123'
      }      
      
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
      
path = Dir.pwd
 
request = CnpOnline::CnpRequest.new({'sessionId'=>'8675309'})
  
request.create_new_cnp_request(path)
puts "Created new CnpRequest at location: " + path
start = Time::now
#create five batches, each with 10 sales
5.times{
  batch = CnpOnline::CnpBatchRequest.new
  batch.create_new_batch(path)
 
  #add the same sale ten times
  10.times{
    batch.sale(saleHash)
  }
 
  #close the batch, indicating we plan to add no more transactions
  batch.close_batch()
  #add the batch to the CnpRequest
  request.commit_batch(batch)
}
 
# puts "Finished adding batches to CnpRequest at " + request.get_path_to_batches
#finish the Cnp Request, indicating we plan to add no more batches
request.finish_request
puts "Generated final XML markup of the CnpRequest"
 
#send the batch files at the given directory over sFTP
request.send_to_cnp
puts "Dropped off the XML of the CnpRequest over FTP"
#grab the expected number of responses from the sFTP server and save them to the given path
request.get_responses_from_server()
puts "Received the CnpRequest responses from the server"
#process the responses from the server with a listener which applies the given block
start = Time::now
request.process_responses({:transaction_listener => CnpOnline::DefaultCnpListener.new do |transaction|
  type = transaction["type"]
  #if we're dealing with a saleResponse (check the Cnp XML Reference Guide!)
  if(type == "saleResponse") then
    #grab an attribute of the parent of the response
    puts "Report Group: " + transaction["reportGroup"]
    
    #grab some child elements of the transaction
    puts "Cnp Txn Id: " + transaction["cnpTxnId"]
    puts "Order Id: " + transaction["orderId"]
    puts "Response: " + transaction["response"]
    
    #grab a child element of a child element of the transation
    puts "AVS Result: " + transaction["fraudResult"]["avsResult"]
    puts transaction["message"]
   # puts "Token Response Message: " + transaction["tokenResponse"]["tokenMessage"] 
    if (!transaction["message"].eql?'Approved')
   raise ArgumentError, "SampleBatchDriver has not been Approved", caller
    end
  end
end})
stop = Time::now
puts "Total time: " + (stop - start).to_s

