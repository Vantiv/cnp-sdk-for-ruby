require_relative '../../lib/CnpOnline'
 
#Void
void_info = {
  #cnpTxnId contains the Cnp Transaction Id returned on the deposit/refund
  'cnpTxnId' => '100000000000000001',
  'id'=>'test'
}
 
response = CnpOnline::CnpOnlineRequest.new.void(void_info)
 
#display results
puts "Response: " + response.voidResponse.response
puts "Message: " + response.voidResponse.message
puts "Cnp Transaction ID: " + response.voidResponse.cnpTxnId

 if (!response.voidResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpVoidTransaction has not been Approved", caller
 end