public class ADBMyUHCController {
    @AuraEnabled
    public static ADBMyUhcDetailsWrapper callMyUhcService(String memberId, String memDob, String memFirstName, String memLastName, String memberPolicy){
        ADBMyUhcDetailsWrapper responseWrapper = new ADBMyUhcDetailsWrapper();
        responseWrapper = ADBMyUhcRegistrationService.callMyUhcServiceDetails(memberId, memDob, memFirstName, memLastName, memberPolicy);
        if(responseWrapper != null){
            if(responseWrapper.lastTimeMemberLoggedInsuccessfully!=null){
                String loggedInDate = responseWrapper.lastTimeMemberLoggedInsuccessfully;
                String formattedDate = loggedInDate.replace('-', '/');
                responseWrapper.formattedLoggedInDate = formattedDate;  
            }
            if(responseWrapper.membersMyUhcRegistrationStatus == 'ACTIVE'){
                responseWrapper.registrationStatus = 'Registered';
            }else if(responseWrapper.membersMyUhcRegistrationStatus == 'DISABLED'){
                responseWrapper.registrationStatus = 'Locked Out';
            }else if(responseWrapper.membersMyUhcRegistrationStatus == null && responseWrapper.responseStatusMessage == 'Member userID not found'){
                responseWrapper.registrationStatus = 'Not Registered';
            }else{
                responseWrapper.registrationStatus = responseWrapper.membersMyUhcRegistrationStatus;
            }
        }   
        system.debug('My uhc registration response wrapper'+ responseWrapper.registrationStatus+responseWrapper.responseStatusMessage);
        return responseWrapper;
    }
}