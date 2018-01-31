require_relative '../../lib/CnpOnline'
#Force Capture
force_capture_info = {
  'merchantId' => '101',
    'id'=>'test',
  'version'=>'8.8',
  'reportGroup'=>'Planets',
  'cnpTxnId'=>'123456',
  'orderId'=>'12344',
  'amount'=>'106',
  'orderSource'=>'ecommerce',
  'card'=>{
    'type'=>'VI',
    'number' =>'4100000000000001',
    'expDate' =>'1210'
  }
}
response= CnpOnline::CnpOnlineRequest.new.force_capture(force_capture_info)
 
#display results
puts "Response: " + response.forceCaptureResponse.response
puts "Message: " + response.forceCaptureResponse.message
puts "Cnp Transaction ID: " + response.forceCaptureResponse.cnpTxnId

if (!response.forceCaptureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpForceCaptureTransaction has not been Approved", caller
end