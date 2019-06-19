=begin
Copyright (c) 2017 Vantiv eCommerce

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
# This file contains the preloaded listeners for parsing the response XML.

module CnpOnline
  # This listener will run the provided closure over every response hash
  # This is the base class for all listeners applied to transaction responses
  class DefaultCnpListener
    def initialize(&action)
      @action = action
    end

    def apply(duck)
      # apply the proc uniformly across all response types
      @action.call(duck)
    end
  end

  class AuthorizationListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "authorizationResponse") then
        @action.call(duck)
      end
    end
  end

  class CaptureListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "captureResponse") then
        @action.call(duck)
      end
    end
  end

  class ForceCaptureListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "forceCaptureResponse") then
        @action.call(duck)
      end
    end
  end

  class CaptureGivenAuthListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "captureGivenAuthResponse") then
        @action.call(duck)
      end
    end
  end

  class SaleListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "saleResponse") then
        @action.call(duck)
      end
    end
  end

  class CreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "creditResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckSaleListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckSaleResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckVerificationListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckVerificationResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckRedepositListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckRedepositResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckPreNoteSaleListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckPreNoteSaleResponse") then
        @action.call(duck)
      end
    end
  end

  class EcheckPreNoteCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "echeckPreNoteCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class SubmerchantCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "submerchantCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class PayFacCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "payFacCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class ReserveCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "reserveCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class VendorCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "vendorCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class FundingInstructionVoidListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "FundingInstructionVoidResponse") then
        @action.call(duck)
      end
    end
  end

  class PinlessDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "PinlessDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class FastAccessFundingListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "FastAccessFundingResponse") then
        @action.call(duck)
      end
    end
  end

  class PhysicalCheckCreditListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "physicalCheckCreditResponse") then
        @action.call(duck)
      end
    end
  end

  class SubmerchantDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "submerchantDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class PayFacDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "payFacDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class ReserveDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "reserveDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class VendorDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "vendorDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class PhysicalCheckDebitListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "physicalCheckDebitResponse") then
        @action.call(duck)
      end
    end
  end

  class AuthReversalListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "authReversalResponse") then
        @action.call(duck)
      end
    end
  end

  class RegisterTokenListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "registerTokenResponse") then
        @action.call(duck)
      end
    end
  end

  class FraudCheckListener < DefaultCnpListener
    def apply(duck)
      if(duck["type"] == "advancedFraudResults") then
        @action.call(duck)
      end
    end
  end

end