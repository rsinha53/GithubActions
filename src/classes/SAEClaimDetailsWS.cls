/*
 * @Desc: US1956058 - Handle the Claim Details WS Callout and the related filter logic 
* @Date: 9/4/2020
* @Dev: Malinda
 */
public class SAEClaimDetailsWS {
    //Error messages
    private static final String CLAIM_DETAILS_WS_GENERAL_ERROR = 'Web Service or External System is temporarily unavailable.';
    //Error codes
    private static final Integer CLAIM_DETAILS_WS_GENERAL_ERROR_CODE = 999;

    /*
     * Claim details WS : get response based on tin,payerId,claimNumber and processed date
	 */
    public ACETWSCalloutResult getClaimInformation(ACET_ClaimDetailController.ClaimInputs claimInputs) {
        String responseStr = '';
        String strParamTin= claimInputs.taxId;
        String strParamPayerId= claimInputs.payerId;
        String strParamClaimNo= claimInputs.claimNumber;
        System.debug('### SAEClaimDetailsWS');
        System.debug('### SAEClaimDetailsWS - strParamTin:'+strParamTin+' strParamPayerId:'+strParamPayerId+' strParamClaimNo:'+strParamClaimNo);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();

            reqPramsMap.put('claimNumber', strParamClaimNo);
            reqPramsMap.put('payerId', strParamPayerId);
            reqPramsMap.put('tin', strParamTin);
			reqPramsMap.put('getUnfilteredLines','True');

            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkClaimDetail';
            wsCallOut.requestParamsMap = reqPramsMap;
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
            if(responseStr != null && String.isNotBlank(responseStr)){
                calloutResult.statusCode= response.getStatusCode();
                SAEEligibilityClaimDetailsJSON2Apex responseObj = SAEEligibilityClaimDetailsJSON2Apex.parse(responseStr);
                System.debug('### SAEClaimDetailsWS - Deserialized responseObj:'+responseObj);

                if(responseObj != null) {
                    if(responseObj.claimsDetailInfo != null && !responseObj.claimsDetailInfo.isEmpty()) {
                   		System.debug('### SAEClaimDetailsWS: Found valid claims to return');
                        //calloutResult.Response = responseObj.claimsDetailInfo[0];
                        calloutResult.Response = responseObj;
                        calloutResult.Success = true;
                    }
                  }
                 }
             }//sravani Error code Handling start
                          else{
                              calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                              calloutResult.Success = false;
                              calloutResult.statusCode = response.getStatusCode();
                              calloutResult.Message = response.getBody();
                              calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
                          }//sravani Error code Handling End
        } catch(Exception e) {
            System.debug('### ERROR: SAEClaimDetailsWS - getClaimInformation');
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = CLAIM_DETAILS_WS_GENERAL_ERROR;
            calloutResult.statusCode = CLAIM_DETAILS_WS_GENERAL_ERROR_CODE;
        }
        System.debug('### SAEClaimDetailsWS - RETURN RESULT:'+calloutResult);
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
            calloutResult.message = getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
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
}