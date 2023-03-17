/*
 * @Desc: US2154803 - View Authrizations and Notifications - Inpatient Details Integration
 * @Date: 31-12-2019
 * @Dev: Kavinda
 */
public class ACET_GetAuthorizationStatusDetails {

    static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String OIL_AUTHENTICATION = 'Stargate';//Stargate_prod
    static final String READ_AUTH_RESOURCE = 'ReadAuth';
    static final String READ_AUTH_BASE_URL = 'https://gateway.optum.com';
    static final String READ_AUTH_SUCCESS_MSG = 'Success';
    static final String READ_AUTH_COMMON_ERROR_MSG = 'Web Service or External System is temporarily unavailable.';
    static final Integer READ_AUTH_ERROR_CODE = 999;
    static final String READ_AUTH_EMPTY_REQUEST_ERROR_MSG = 'Read Auth request body is empty!';
    
    public String getRequestBody(AuthDetailsRequest requestObj) {
        String requestBody = '{"authDetailsRequest":{"identifiers":[{"id":"' + requestObj.AUTH_ID.trim() + '","typeCode":"AUTHID"},{"id":"' + requestObj.XREF_ID.trim() + '","typeCode":"XREFID"}]}}';
        return requestBody;
    }

    public ACETWSCalloutResult readAuth(AuthDetailsRequest requestObj) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_AuthorizationStatusResponse responseObj;
        
        try {

            if (requestObj != null) {
                HttpResponse response;
                // US3636832: Migration of authSummary and authDetail APIs to new framework- Swapnil
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'GetAuthorization';
                wsCallOutFW.requestBody = getRequestBody(requestObj);
                response = wsCallOutFW.getResponse();
                // US3636832 - Swapnil

                /* //if current org is production
                Boolean isStaticResponseChecked = SAEUtils.getMockStatus();
                if (isStaticResponseChecked && !Test.isRunningTest()) {
                    //Prepare the file name
                    String searchparameter = 'readAuth_'+requestObj.AUTH_ID.trim()+'_'+requestObj.XREF_ID.trim();
                    system.debug('searchparameter 1 ::: '+searchparameter); 
                    //vishnu- 30/04/2020
                    response=SAEUtils.getResponse(searchparameter);  
                    
                }else{
                    response = Send(OAuthConfig);
                } */
                
                String strJson = response.getBody();
                String strJsonMod = strJson.replaceAll('"desc":', '"desc_x":');
                System.debug(Logginglevel.ERROR, '### READ-AUTH-strJsonMod:' + strJsonMod);
                if (response.getStatusCode() == RESPONSE_SUCCESS_CODE) {
                    responseObj = (ACET_AuthorizationStatusResponse) JSON.deserialize(strJsonMod, ACET_AuthorizationStatusResponse.class);
                    if (responseObj != null) {
                        calloutResult.Success = true;
                        calloutResult.Message = READ_AUTH_SUCCESS_MSG;
                        calloutResult.statusCode = RESPONSE_SUCCESS_CODE;
                        calloutResult.Response = responseObj;
                    }
                }//US2331223 Assigning custom error message based on response status code _by vishnu
                else if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(response.getStatusCode()))
				{
					calloutResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
					calloutResult.statusCode = response.getStatusCode();
					calloutResult.Response = responseObj;
				}
                else
                {
					calloutResult.Message = READ_AUTH_COMMON_ERROR_MSG;
					calloutResult.statusCode = response.getStatusCode();
					calloutResult.Response = responseObj;
            	}

            } else {
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message =READ_AUTH_COMMON_ERROR_MSG;
                calloutResult.statusCode = READ_AUTH_ERROR_CODE;
            }

        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, '### READ-AUTH-EXCEPTION:' + e.getStackTraceString() + ' - ' + e.getMessage());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = READ_AUTH_COMMON_ERROR_MSG;
            calloutResult.statusCode = READ_AUTH_ERROR_CODE;
        }
        System.debug(Logginglevel.INFO, '###=calloutResult.Response:' + calloutResult.Response);
        return calloutResult;
    }

    

    public class AuthDetailsRequest {
        @AuraEnabled public String AUTH_ID {get; set;}
        @AuraEnabled public String XREF_ID {get; set;}
    }

}