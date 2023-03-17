public without sharing class ADBAuthorizationResponseWrapper {
    
    @AuraEnabled public UnetResponse unetResponse;
    public class UnetResponse{ 
        @AuraEnabled public List<Notifications> notifications; 
        @AuraEnabled public List<Errors> errors;
    }
    public class Notifications {
        @AuraEnabled public String notificationNumber;
        @AuraEnabled public String advancedNotificationDate; 
        @AuraEnabled public List<ParsInfos> parsInfos;
        @AuraEnabled public ProgramRecordIndicator programRecordIndicator;
    }
    public class ParsInfos {
        @AuraEnabled public String cancelDate; 
        @AuraEnabled public String effectiveDate; 
        @AuraEnabled public List<CptDetails> cptDetails; 
        @AuraEnabled public Remark remark;
    } 
    public class Remark{
        @AuraEnabled public String code;
        @AuraEnabled public String description;
    }
    public class ProgramRecordIndicator{
        @AuraEnabled public String description;
    }
    public class CptDetails{
        @AuraEnabled public Procedure procedure;
    }
    public class Procedure{
        @AuraEnabled public String code;
    }
    public class Errors {
        @AuraEnabled public String code;
        @AuraEnabled public String name;
        @AuraEnabled public String description;
    }
	    public static ADBAuthorizationResponseWrapper parse(String json) {
        return (ADBAuthorizationResponseWrapper) System.JSON.deserialize(json, ADBAuthorizationResponseWrapper.class);
    } 
}