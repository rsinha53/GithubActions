public without sharing class ADBMyUhcRegistrationService {
    @AuraEnabled
    public static ADBMyUhcDetailsWrapper callMyUhcServiceDetails(String memberId, String memDob, String memFirstName, String memLastName, String memberPolicy){
        ADBMyUhcDetailsWrapper myUhcWrapper = new ADBMyUhcDetailsWrapper();
        try{
            myUhcWrapper.groupId = memberPolicy;
            myUhcWrapper.firstName = memFirstName;
            myUhcWrapper.lastName = memLastName;
            myUhcWrapper.dob = ACETUtility.formatDatewithslash(memDob);
            myUhcWrapper.memberId = memberId;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMyUhcServiceEndpoint', JSON.serialize(myUhcWrapper), null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200) {
                myUhcWrapper = (ADBMyUhcDetailsWrapper) JSON.deserialize(response.getBody(), ADBMyUhcDetailsWrapper.class);
            } 
            else{
                system.debug('My Uhc Registration Service Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('My Uhc Registration Service Exception ::' + e.getMessage());
        }
        return myUhcWrapper;
    }
}