require_relative '../../lib/CnpOnline'
 
#Auth Reversal
#cnpTxnId contains the Cnp Transaction Id returned on the authorization
reversal_info = {'id'=>'test','cnpTxnId' => '100000000000000001'}
reversal_response = CnpOnline::CnpOnlineRequest.new.auth_reversal(reversal_info)
 
#display results
puts "Response: " + reversal_response.authReversalResponse.response
puts "Message: " + reversal_response.authReversalResponse.message
puts "Cnp Transaction ID: " + reversal_response .authReversalResponse.cnpTxnId

if (!reversal_response.authReversalResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpAuthReversalTransaction has not been Approved", caller
end
