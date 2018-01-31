require_relative '../../lib/CnpOnline'
#Credit
#cnpTxnId contains the Cnp Transaction Id returned on 
#the capture or sale transaction being credited
#the amount is optional, if it isn't submitted the full amount will be credited
credit_info =  {'id'=>'test','cnpTxnId' => '100000000000000002', 'amount' => '1010'}
credit_response = CnpOnline::CnpOnlineRequest.new.credit(credit_info)
 
#display results
puts "Response: " + credit_response.creditResponse.response
puts "Message: " + credit_response.creditResponse.message
puts "Cnp Transaction ID: " + credit_response.creditResponse.cnpTxnId

 if (!credit_response.creditResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpCreditTransaction has not been Approved", caller
 end