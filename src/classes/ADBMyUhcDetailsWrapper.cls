public without sharing class ADBMyUhcDetailsWrapper {
    
    // Request parameters for the service
    @AuraEnabled public String groupId{ get; set; } 
    @AuraEnabled public String firstName{ get; set; } 
    @AuraEnabled public String lastName{ get; set; } 
    @AuraEnabled public String dob{ get; set; } 
    @AuraEnabled public String memberId{ get; set; } 
    
    // Response parameters for the service
    @AuraEnabled public String lastTimeMemberLoggedInsuccessfully; 
    @AuraEnabled public String membersMyUhcRegistrationStatus; 
    @AuraEnabled public String responseStatusMessage; 
    @AuraEnabled public String registrationStatus; 
    @AuraEnabled public String formattedLoggedInDate; 
    public static ADBMyUhcDetailsWrapper parse(String json) {
        return (ADBMyUhcDetailsWrapper) System.JSON.deserialize(json, ADBMyUhcDetailsWrapper.class);
    }
}