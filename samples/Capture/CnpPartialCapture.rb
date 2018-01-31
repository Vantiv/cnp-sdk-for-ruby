require_relative '../../lib/CnpOnline'
#Partial Capture
#cnpTxnId contains the Cnp Transaction Id returned as part of the authorization
#submit the amount to capture which is less than the authorization amount
#to generate a partial capture
capture_info =  {'id'=>'test','cnpTxnId' => '320000000000000001', 'amount' => '5005'}
capture_response = CnpOnline::CnpOnlineRequest.new.capture(capture_info)
 
#display results
puts "Response: " + capture_response.captureResponse.response
puts "Message: " + capture_response.captureResponse.message
puts "Cnp Transaction ID: " + capture_response.captureResponse.cnpTxnId

if (!capture_response.captureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpPartialCapture has not been Recieved", caller
end