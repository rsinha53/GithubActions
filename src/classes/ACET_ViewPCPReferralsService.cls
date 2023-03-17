public class ACET_ViewPCPReferralsService {
    
    public ACET_SAECalloutResult getPolicesInfo(ACET_ViewPCPReferralsRequest inpPCPRequest) {
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            String responseStr = '';
            HttpResponse referralResponse;

            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('memberId', string.isNotBlank(inpPCPRequest.memberId) ? inpPCPRequest.memberId : '');
            requestParamsMap.put('policyNumber', string.isNotBlank(inpPCPRequest.policyNumber) ? inpPCPRequest.policyNumber : '');
            requestParamsMap.put('dateOfBirth', string.isNotBlank(inpPCPRequest.dateOfBirth) ? inpPCPRequest.dateOfBirth : '');
            requestParamsMap.put('firstName', string.isNotBlank(inpPCPRequest.firstName) ? inpPCPRequest.firstName : '');
            requestParamsMap.put('firstDateOfService', string.isNotBlank(inpPCPRequest.firstDateOfService) ? inpPCPRequest.firstDateOfService : '');
            requestParamsMap.put('lastDateOfService', string.isNotBlank(inpPCPRequest.lastDateOfService) ? inpPCPRequest.lastDateOfService : '');
            requestParamsMap.put('payerId', string.isNotBlank(inpPCPRequest.payerId) ? inpPCPRequest.payerId : '');
            requestParamsMap = processMockRequest ('LinkViewPCPReferrals',inpPCPRequest,requestParamsMap);
            System.debug('@@ ACET_ViewReferralsService: getPolicesInfo: requestParamsMap:'+requestParamsMap);

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkViewPCPReferrals';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            referralResponse = wsCallOutFW.getResponse();


            /*Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ ACET_ViewReferralsService: getPolicesInfo: isStaticResponseChecked: '+isStaticResponseChecked);
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                string searchparameter = 'ReferralService_'+inpPCPRequest.memberId+'_'+inpPCPRequest.policyNumber;
                if(string.isNotBlank(inpPCPRequest.alloff) && inpPCPRequest.alloff == '1')  searchparameter = 'ReferralService_'+inpPCPRequest.memberId+'_'+inpPCPRequest.policyNumber+'_'+inpPCPRequest.alloff;
                if(string.isNotBlank(inpPCPRequest.newReferralNumber)) searchparameter = searchparameter + '_'+ (inpPCPRequest.newReferralNumber.length() >=1 ? inpPCPRequest.newReferralNumber.substring(0,1): '');
                referralResponse = SAEUtils.getResponse(searchparameter);
            }
            else{

                Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
                String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
                Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
                String endPoint = islWebserviceData.get(orgName + '_ViewPCPReferrals').Value__c;
                string resultQuery = '?';
                resultQuery +=  string.isNotBlank(inpPCPRequest.memberId) ? 'memberId='+inpPCPRequest.memberId : 'memberId=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.policyNumber) ? '&policyNumber='+inpPCPRequest.policyNumber : '&policyNumber=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.dateOfBirth) ? '&dateOfBirth='+inpPCPRequest.dateOfBirth : '&dateOfBirth=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.firstName) ? '&firstName='+inpPCPRequest.firstName : '&firstName=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.firstDateOfService) ? '&firstDateOfService='+inpPCPRequest.firstDateOfService : '&firstDateOfService=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.lastDateOfService) ? '&lastDateOfService='+inpPCPRequest.lastDateOfService : '&lastDateOfService=';
                resultQuery +=  string.isNotBlank(inpPCPRequest.payerId) ? '&payerId='+inpPCPRequest.payerId : '&payerId=';
                referralResponse = SAEWebservice.makeCallout(resultQuery, endPoint, 'GET');
            }*/
            System.debug('===@@RESPONSE:'+referralResponse);
            System.debug('===@@RESPONSE-BODY:'+referralResponse.getBody());
            Integer refferalStatusCode = referralResponse.getStatusCode();
            String strReferralResponseBody = referralResponse.getBody();
            if(refferalStatusCode == 200){
                Map<string,string> currentPolicyandPayerMap = new Map<String,String>();
                if(string.isNotBlank(strReferralResponseBody)){
                    ACET_ViewPCPReferralsResponse responseData = ACET_ViewPCPReferralsResponse.parse(strReferralResponseBody);
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = refferalStatusCode;
                    calloutResult.Response = responseData; 
                }
            }
            else{ 
                system.debug('Error@@@ ' + referralResponse.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = refferalStatusCode;
                calloutResult.Message = getErrroMessage(refferalStatusCode, referralResponse.getBody());
                if(string.isBlank(calloutResult.Message))  calloutResult.Message = 'Refferal - Web Service or External System is temporarily unavailable.';
            }
            
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
   
    public  static Map < String, String > processMockRequest(string serviceName,ACET_ViewPCPReferralsRequest inpPCPRequest,Map < String, String > requestParamsMap){
        try {
            string orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
            WebserviceConfigurations__c wsConfig = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c,
                                                    Handle_Unauthorized__c,
                                                    (SELECT EnableLogs__c, EnableMock__c, EnableMockForProfiles__c, EndpointDomain__c, ErrorReportingEmailIds__c, SendEmailOnError__c FROM OrgSpecificConfigurations__r WHERE Name =: orgName LIMIT 1)
                                                    FROM WebserviceConfigurations__c WHERE Name =: serviceName LIMIT 1
                                                   ];
            OrgSpecificConfigurations__c orgSpecificConfigs = wsConfig.OrgSpecificConfigurations__r;
            if (orgSpecificConfigs.EnableMock__c && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).OverrideEnableMock__c || Organization_Properties__c.getInstance(UserInfo.getUserId()).OverrideEnableMock__c)) {
                if (String.isNotBlank(orgSpecificConfigs.EnableMockForProfiles__c)) {
                    String userProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
                    if (orgSpecificConfigs.EnableMockForProfiles__c.split(',').contains(userProfileName)) {
                        requestParamsMap.put('alloff', string.isNotBlank(inpPCPRequest.alloff) ? inpPCPRequest.alloff: '' );
                        requestParamsMap.put('newReferralNumber', string.isNotBlank(inpPCPRequest.newReferralNumber) ? inpPCPRequest.newReferralNumber: '' );

                    }
                } else {
                    requestParamsMap.put('alloff', string.isNotBlank(inpPCPRequest.alloff) ? inpPCPRequest.alloff: '' );
                    requestParamsMap.put('newReferralNumber', string.isNotBlank(inpPCPRequest.newReferralNumber) ? inpPCPRequest.newReferralNumber: '' );
                }
            }
        } catch (Exception e) {
            system.debug('@@Exception@@'+e.getMessage()+'@'+e.getStackTraceString());
        }
        return requestParamsMap;
    }

    public static string getErrroMessage(Integer StatusCode, string errorResponse){
        string errorMessage = '';
        if(string.isNotBlank(errorResponse)){
            Map<String, Object> errorResponeMap = (Map<String, Object>)JSON.deserializeUntyped(errorResponse);
            string faultCode = errorResponeMap.get('faultCode') != NULL ? string.valueof(errorResponeMap.get('faultCode')) : '';
            string message =  errorResponeMap.get('message') != NULL ? string.valueof(errorResponeMap.get('message')) : '';
            if(string.isNotBlank(faultCode) &&  string.isNotBlank(message)){
                 errorMessage = 'Refferal- Fault Code: '+ faultCode + ' and Message: '+ message;
            }
        }
        return errorMessage; 
    }
    
    public class ACET_ViewPCPReferralsRequest {
        @AuraEnabled public string memberId{get;set;} //Required
        @AuraEnabled public string policyNumber{get;set;}
        @AuraEnabled public string dateOfBirth{get;set;} //Required
        @AuraEnabled public string firstName{get;set;} // Required
        @AuraEnabled public string firstDateOfService{get;set;} //Required
        @AuraEnabled public string lastDateOfService{get;set;} //Required
        @AuraEnabled public string payerId{get;set;} //Required
        @AuraEnabled public string alloff{get;set;}
        @AuraEnabled public string newReferralNumber{get;set;}
    }
    
}