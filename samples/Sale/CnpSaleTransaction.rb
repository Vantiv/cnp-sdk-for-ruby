require_relative '../../lib/CnpOnline'
#Sale
my_sale_info = {
  'orderId' => '1',
  'id'=>'test',
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
  'number' =>'4100000000000001',
  'expDate' => '0112',
  'cardValidationNum' => '349',
  'type' => 'MC'}
}
sale_response = CnpOnline::CnpOnlineRequest.new.sale(my_sale_info)
 
#display results
puts "Response: " + sale_response.saleResponse.response
puts "Message: " + sale_response.saleResponse.message
puts "Cnp Transaction ID: " + sale_response.saleResponse.cnpTxnId

if (!sale_response.saleResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpSaleTransaction has not been Approved", caller
end