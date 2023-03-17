public without sharing class ADBFunctionalRoleResponseWrapper {
    // Response Params
    @AuraEnabled
    public userDetailsResponse userDetailsResponse;
    @AuraEnabled
    public String role;
    public class userDetailsResponse{
        @AuraEnabled
        public userDetails userDetails;
        @AuraEnabled
        public responseHeader responseHeader;
    }
    public class responseHeader{
        @AuraEnabled
        public String serviceCallStatusCode;
        @AuraEnabled
        public String serviceCallStatus;
    }
    public class userDetails{
        @AuraEnabled
        public String functionalRoleType;
    }
    public static ADBFunctionalRoleResponseWrapper parse(String json) {
        return (ADBFunctionalRoleResponseWrapper) System.JSON.deserialize(json, ADBFunctionalRoleResponseWrapper.class);
    } 
}