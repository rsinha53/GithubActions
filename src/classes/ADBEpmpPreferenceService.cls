public without sharing class ADBEpmpPreferenceService{
    // method for calling the epmp service : US2368815 - sunil vennam 
    public static ADBEpmpPreferenceResponseWrapper callEpmpPreferenceService(String memberId, String memFirstName, String memLastName, String memDob, String policyNumber){
        ADBEpmpPreferenceRequestWrapper request = new ADBEpmpPreferenceRequestWrapper();
        ADBEpmpPreferenceResponseWrapper responseWrapper = new ADBEpmpPreferenceResponseWrapper();
        String dob = '';
        // converting date format as per the service
        if(memDob!=null){
            dob = ACETUtility.formatDatewithslash(memDob);
        }
        // Get the Authorization token to pass as a header to the service
        request.first_nm = memFirstName;
        request.lst_nm = memLastName;
        request.subscriber_id = memberId;
        request.policy_nbr = policyNumber;
        request.dob = dob;
        request.calling_app_name = 'ACET';
        request.user_id = 'ACET';
        request.user_type = 'application';
        String serializedBody = JSON.serialize(request);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpPreferencesEndpoint', serializedBody, null);
        HttpResponse response = wsCallOutFW.getResponse();
        system.debug('response'+ response.getBody());
        if(response.getStatusCode() == 200){
            // Deserializing response
            responseWrapper = ADBEpmpPreferenceResponseWrapper.parse(response.getBody());
        }else{
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }
    
    // method for calling the epmp Alerts service : US2382023 - Sunil Vennam
    public static ADBEpmpAlertsResponseWrapper callEpmpAlertsService(String memberId, String memFirstName, String memLastName, String memDob, String policyNumber){
        ADBEpmpAlertsRequestWrapper request = new ADBEpmpAlertsRequestWrapper();
        ADBEpmpAlertsResponseWrapper responseWrapper = new ADBEpmpAlertsResponseWrapper();
        String dob = '';
        // converting date format as per the service
        if(memDob!=null){
            dob = ACETUtility.formatDatewithslash(memDob);
        }
        // Get the Authorization token to pass as a header to the service
        request.first_nm = memFirstName;
        request.lst_nm = memLastName;
        request.subscriber_id = memberId;
        request.policy_nbr = policyNumber;
        request.dob = dob;
        request.includeAlertsInResponse = 'Y';
        request.includeContactInfoInResponse = 'N';
        request.calling_app_name = 'ACET';
        request.user_id = 'ACET';
        request.user_type = 'Application';
        String serializedBody = JSON.serialize(request);
        // Actual service to call the epmp service response
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBAlertsPreferenceEndpoint', serializedBody, null);
        HttpResponse response = wsCallOutFW.getResponse();
        system.debug(' Alerts response'+ response.getBody());
        if(response.getStatusCode() == 200){
            // Deserializing response
            responseWrapper = ADBEpmpAlertsResponseWrapper.parse(response.getBody());
        }else{
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }
}