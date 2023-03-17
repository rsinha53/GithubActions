// Response wrapper for Alerts API -  US2382023 - Sunil Vennam
public without sharing class ADBEpmpAlertsResponseWrapper {
    @AuraEnabled public String responseCode;
    @AuraEnabled public String responseMsg;
    @AuraEnabled public String responseDetailMsg;    
    @AuraEnabled public string epmpEnabled;
    @AuraEnabled public alertList alertList;
    public class alertList{
        @AuraEnabled public status status; 
    }
    public class status{
        @AuraEnabled public messages messages; 
    }
    public class messages{
        @AuraEnabled public List<message> message; 
    }
    public class message{
        @AuraEnabled public String name;
        @AuraEnabled public String description;
        @AuraEnabled public String longDescription;
        @AuraEnabled public String type_X;
    }
    public static ADBEpmpAlertsResponseWrapper parse(String json) {
        return (ADBEpmpAlertsResponseWrapper) System.JSON.deserialize(json.replace('type', 'type_X'), ADBEpmpAlertsResponseWrapper.class);
    } 
}