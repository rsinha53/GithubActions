public class ACETIPAMarketAssociationWS {
    @AuraEnabled public String appName {get;set;}
    @AuraEnabled public String marketNumber {get;set;}
    @AuraEnabled public String marketType {get;set;}
    @AuraEnabled public String ipa {get;set;}
    
    public ACETWSCalloutResult call_IPA_MarketAssociation_API(SAEPolicyDetailsController.IPAMarketInputs ipaInputs) {
        String responseStr = '';
        String strAppName= ipaInputs.appName;
        String strMarketNumber= ipaInputs.marketNumber;
        String strMarketType= ipaInputs.marketType;
        String strIpa= ipaInputs.ipa;
        System.debug('### ACETIPAMarketAssociationWS');
        System.debug('### ACETIPAMarketAssociationWS - strAppName:'+strAppName+' strMarketNumber:'+strMarketNumber+' strMarketType:'+strMarketType+' strIpa:'+strIpa);
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();
            reqPramsMap.put('app-nm', strAppName);
            reqPramsMap.put('prov-market-nbr', strMarketNumber);
            reqPramsMap.put('prov-market-type', strMarketType);
            reqPramsMap.put('prov-ipa-nbr', strIpa);

            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'IPAMarketAssociationService';
            wsCallOut.requestParamsMap = reqPramsMap;
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    calloutResult.statusCode= response.getStatusCode();
                    ACETIPAMarketAssociationResponseWrapper responseObj=ACETIPAMarketAssociationResponseWrapper.parse(responseStr);
                    System.debug('### ACETIPAMarketAssociationWS - Deserialized responseObj:'+responseObj);

                if(responseObj != null) {
                    if(responseObj.svcResponse != null && !responseObj.svcResponse.isEmpty()) {
                   		System.debug('### ACETIPAMarketAssociationWS: Found valid claims to return');
                        //calloutResult.Response = responseObj.claimsDetailInfo[0];
                        calloutResult.Response = responseObj;
                        calloutResult.Success = true;
                    }
                  }
                }
            }
            else{
				        calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                        calloutResult.Success = false;
                        calloutResult.statusCode = response.getStatusCode();
                        calloutResult.Message = response.getBody();
                        //calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
              }
        }catch(Exception e) {
            System.debug('### ERROR: ACETIPAMarketAssociationWS - call_IPA_MarketAssociation_API');
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            //calloutResult.Message = CLAIM_DETAILS_WS_GENERAL_ERROR;
            //calloutResult.statusCode = CLAIM_DETAILS_WS_GENERAL_ERROR_CODE;
        }
        System.debug('### ACETIPAMarketAssociationWS - RETURN RESULT:'+calloutResult);
        return calloutResult;
    }

}