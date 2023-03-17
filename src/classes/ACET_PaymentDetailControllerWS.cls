public class ACET_PaymentDetailControllerWS {
    
    public ACETWSCalloutResult getPaymentDetailsWS(String taxid,String payerId,String transactionId){
        System.debug('The claim input coming is: '+ taxid);
        String responseStr = '';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        List<ACET_PaymentDetailController_Json2Apex.Payments> ResponseArray = new List<ACET_PaymentDetailController_Json2Apex.Payments>();
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkPaymentDetail';
            reqPramsMap.put('tin',taxid);
            reqPramsMap.put('payerId',payerId );
            reqPramsMap.put('transactionId',transactionId);
            wsCallOut.requestParamsMap = reqPramsMap;
            System.debug('calling new framework'+reqPramsMap);
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
            	if(responseStr != null && String.isNotBlank(responseStr)){
                calloutResult.statusCode= response.getStatusCode();
                ACET_PaymentDetailController_Json2Apex responseObj = ACET_PaymentDetailController_Json2Apex.parse(responseStr);
                System.debug('### ACET_PaymentDetailControllerWS - Deserialized responseObj:'+responseObj);
                if(responseObj != null) {
                    if(responseObj.payments != null && !responseObj.payments.isEmpty()) {
                        calloutResult.Response = responseObj.payments;
                        calloutResult.Success = true;
                    }else {
                        calloutResult.Success = false;
                        System.debug('### ERROR: ACET_PaymentDetailControllerWS - EMPTY CLAIMS');
                    }
                }else {
                    calloutResult.Success = false;
                    System.debug('### ERROR: ACET_PaymentDetailControllerWS - HTTP ERROR');
                    System.debug('### ERROR: ACET_PaymentDetailControllerWS - HTTP ERROR CODE:'+response.getStatusCode());
                    System.debug('### ERROR: ACET_PaymentDetailControllerWS - HTTP ERROR MSG:'+response.getStatus());
                }
            }
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
            }
        }Catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    

    //sravani start--> Eror code handling
    public static ACETWSCalloutResult getErrorResponse(Integer statusCode, String responseBody) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        calloutResult.Success = false;
        calloutResult.message = '';
        calloutResult.statusCode = statusCode;
       // calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';

        Map < String, Object > httpResponseJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseBody);
        String faultCode = (String) httpResponseJSON.get('faultCode');
        if (statusCode == 400) {
            calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        } else if (statusCode == 401) {
            calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        } else if (statusCode == 404) {
            calloutResult.message = 'No Results Found';
        } else if (statusCode == 500) {
            if (faultCode.containsIgnoreCase('LCLM_S_302')) {
                calloutResult.message = getErrorMessage(faultCode);
            }
        } else if (statusCode == 503) {
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        }
        else {
            calloutResult.message = getErrorMessage(SAEConstants.GN500A)+ '(' + faultCode + ')';
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }
    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode) {
        String errorMessage = '';
        AcetErrorMessage__mdt[] errorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c FROM AcetErrorMessage__mdt WHERE DeveloperName =: errorCode];
        if (errorCodes.size() > 0) {
            errorMessage = errorCodes[0].Error_Message__c;
        }
        return errorMessage;
    }
    
    public static String getPaymentStatusImageWS(String checkNbr,String chkSrsDesg){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        STring URL='';
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkClaimPaymentImage';
             Map<String,String> requestMap=new Map<String,String>();
            requestMap.put('tin','999999999');
            requestMap.put('paymentType','CHK');
            requestMap.put('paymentRefNumber',checkNbr);
            requestMap.put('checkSeriesDesignator',chkSrsDesg);  
            wsCallOut.requestParamsMap = requestMap;
            System.debug('calling new framework'+requestMap);
            HttpResponse response = wscallout.getResponse();
            if(response.getStatusCode() == 200){
            	if(response.getBody() != null && String.isNotBlank(response.getBody())){
                URL=response.getBody();
            }
            }
        }Catch(Exception e){
            
        }
        return URL;
    }
}