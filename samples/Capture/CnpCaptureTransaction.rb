require_relative '../../lib/CnpOnline'
#Capture
#cnpTxnId contains the Cnp Transaction Id returned on the authorization
capture_info =  {'id'=>'test','cnpTxnId' => '100000000000000001'}
capture_response = CnpOnline::CnpOnlineRequest.new.capture(capture_info)
 
#display results
puts "Response: " + capture_response.captureResponse.response
puts "Message: " + capture_response.captureResponse.message
puts "Cnp Transaction ID: " + capture_response .captureResponse.cnpTxnId

if (!capture_response.captureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpCaptureTransaction has not been Approved", caller
end