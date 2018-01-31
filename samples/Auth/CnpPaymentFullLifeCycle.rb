require_relative '../../lib/CnpOnline'
 
#Authorization
#Puts a hold on the funds
auth_hash = {
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
  'number' =>'4**************9',
  'expDate' => '0112',
  'cardValidationNum' => '349',
  'type' => 'VI'}
}
auth_response = CnpOnline::CnpOnlineRequest.new.authorization(auth_hash)
 
#Capture
#Captures the authorization and results in money movement
capture_hash =  {'id'=>auth_response.authorizationResponse.id,
                  'cnpTxnId' => auth_response.authorizationResponse.cnpTxnId}
capture_response = CnpOnline::CnpOnlineRequest.new.capture(capture_hash)

if (!capture_response.captureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpPaymentFullLifeCycle's Capture Transaction has not been Approved", caller
end
#Credit
#Refund the customer
credit_hash =  {'id'=>capture_response.captureResponse.id,
                'cnpTxnId' => capture_response.captureResponse.cnpTxnId}

credit_response = CnpOnline::CnpOnlineRequest.new.credit(credit_hash)

if (!credit_response.creditResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpPaymentFullLifeCycle's credit Transaction has not been Approved", caller
end
#Void
#Cancel the refund, note that a deposit can be Voided as well
void_hash =  {'id'=>credit_response.creditResponse.id,
              'cnpTxnId' => credit_response.creditResponse.cnpTxnId}

void_response = CnpOnline::CnpOnlineRequest.new.void(void_hash)

if (!void_response.voidResponse.message.eql?'Transaction Received')
   raise ArgumentError, "CnpPaymentFullLifeCycle's Void Transaction has not been Approved", caller
end
