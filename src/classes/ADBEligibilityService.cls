public without sharing class ADBEligibilityService { 
    //  Constant Request parameter values Eligibility V2 Service
    final static String SEARCH_OPTION = 'MemberIDNameGroupNumberDateOfBirth';
    final static String PAYER_ID = '87726';
    final static String PROVIDER_LASTNAME = 'ACET';
    final static String TAXID_NUMBER = '9999999';
    final static String PROVIDERNAME_ID = '9999999';
    
    // get Eligibility V2 Response
    @AuraEnabled
    public static ADBEligibilityResponseWrapper getEligibilityV2Response(String reqmemberId, String reqmemberDob,String firstName,String lastName,String groupNumber) {
        
        ADBEligibilityResponseWrapper responseWrapper = new ADBEligibilityResponseWrapper();
        HttpResponse response;
        // Creating request for Eligibility V2 Service
        String searchOption = SEARCH_OPTION;
        String payerId = PAYER_ID;
        String providerLastName = PROVIDER_LASTNAME;
        String dateOfBirth = reqmemberDob;
        String memberId = reqmemberId; 
        String taxIdNumber = TAXID_NUMBER;
        String providerNameID = PROVIDERNAME_ID;
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('searchOption', searchOption);
        requestParamsMap.put('payerID', payerId);
        requestParamsMap.put('providerLastName', providerLastName);
        requestParamsMap.put('dateOfBirth', dateOfBirth);
        requestParamsMap.put('memberId', memberId);
        requestParamsMap.put('taxIdNumber', taxIdNumber);
        requestParamsMap.put('providerNameID', providerNameID);
		requestParamsMap.put('firstName', firstName);
        requestParamsMap.put('lastName', lastName);
        requestParamsMap.put('groupNumber', groupNumber);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('LinkEligibilityMemberSearch', '',requestParamsMap);
        response = wsCallOutFW.getResponse();

        // Mock Eligibilities Response --- Begin
        /*if (memberId == '036169100') { // Brogan Family - termed member
            String memberMockData = 'ADBEligibilityMockResponseBroganFamily';
            StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
            response.setBody(mock.body.toString());
            response.setStatusCode(200);
        }*/
        // Mock Eligibilities Response --- End

        system.debug('Eligibility v2 Response'+ response.getBody());
        if(response.getStatusCode() == 200) {
            responseWrapper = (ADBEligibilityResponseWrapper) JSON.deserialize(response.getBody(),
                                                                               ADBEligibilityResponseWrapper.class);
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }
    
    // get Eligibility Extended service data
    @AuraEnabled
    public static ADBEligibilityExtendedResponseWrapper getExtendedEligibilities(String transactionId,String reqmemberId, String reqmemberDob) {
        
        ADBEligibilityExtendedResponseWrapper responseWrapper = new ADBEligibilityExtendedResponseWrapper();
        HttpResponse response;
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('transactionId', transactionId);
        system.debug('transaction id'+transactionId);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('LinkExtendedCoverage', '',requestParamsMap);
        response = wsCallOutFW.getResponse();
        system.debug('Eligibility Extended Response'+ response.getBody());
        if(response.getStatusCode() == 200) {
            responseWrapper = (ADBEligibilityExtendedResponseWrapper) JSON.deserialize(response.getBody(),
                                                                                       ADBEligibilityExtendedResponseWrapper.class);
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;        
    } 
    
    // get Language Preference
    @AuraEnabled
    public static ADBLanguagePreferenceResponseWrapper getLanguagePreference(String transactionId,String reqmemberId) {        
        ADBLanguagePreferenceResponseWrapper responseWrapper = new ADBLanguagePreferenceResponseWrapper();
        HttpResponse response;
        system.debug('transaction id'+transactionId);
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('transactionId', transactionId);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('LinkLanguagePrefEndpoint', '',requestParamsMap);
        response = wsCallOutFW.getResponse();
        system.debug('Language Preference Response'+ response.getBody());
        if(response.getStatusCode() == 200) {
            responseWrapper = (ADBLanguagePreferenceResponseWrapper) JSON.deserialize(response.getBody(),
                                                                                      ADBLanguagePreferenceResponseWrapper.class);
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }
}