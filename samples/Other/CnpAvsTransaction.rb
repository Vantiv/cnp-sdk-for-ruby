require_relative '../../lib/CnpOnline'
 @@merchant_hash = {'reportGroup'=>'Planets','id'=>'321','customerId'=>'123',
      'merchantId'=>'101',
      'id'=>'test'
    }
#AVS Only
auth_info = {
  'orderId' => '1',
  'amount' => '10010',
  'orderSource'=>'ecommerce',
  'billToAddress'=>{
  'name' => 'John Smith',
  'addressLine1' => '1 Main St.',
  'city' => 'Burlington',
  'state' => 'MA',
  'zip' => '01803-3747',
  'country' => 'US'},
  'card'=>{
  'number' =>'4457010000000009',
  'expDate' => '0112',
  'cardValidationNum' => '349',
  'type' => 'VI'}
} 
hash = auth_info.merge(@@merchant_hash)
auth_response = CnpOnline::CnpOnlineRequest.new.authorization(hash)
 
#display results
puts "Response: " + auth_response.authorizationResponse.response
puts "Message: " + auth_response.authorizationResponse.message
puts "Cnp Transaction ID: " + auth_response.authorizationResponse.cnpTxnId
puts "AVS Match: " + auth_response.authorizationResponse.fraudResult.avsResult

 if (!auth_response.authorizationResponse.message.eql?'Approved')
   raise ArgumentError, "CnpAvsTransaction has not been Approved", caller
 end