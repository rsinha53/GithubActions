public without sharing class ADBFunctionalRoleRequestWrapper {
    // Request params
    @AuraEnabled
    public memberDetailRequest memberDetailRequest;
    public class memberDetailRequest{
        @AuraEnabled
        public requestHeader requestHeader;
    }
    public class requestHeader{
        @AuraEnabled
        public String userID;
    }
}