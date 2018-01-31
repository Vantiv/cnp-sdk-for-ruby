require_relative '../../lib/CnpOnline'
# Visa $10 Sale
cnpSaleTxn = {
    'merchantId' => '087900',
    'id' => 'test',
    'reportGroup'=>'rpt_grp',
    'orderId'=>'1234567',
    'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1212'},
        'orderSource'=>'ecommerce',
        'amount'=>'1000'
    }
 
# Peform the transaction on the Cnp Platform
response = CnpOnline::CnpOnlineRequest.new.sale(cnpSaleTxn)
 
# display results
puts "Message: "+ response.message
puts "Cnp Transaction ID: "+ response.saleResponse.cnpTxnId  

if (!response.saleResponse.message.eql?'Transaction Received')
   raise ArgumentError, "SampleSaleTransaction has not been Approved", caller
end  