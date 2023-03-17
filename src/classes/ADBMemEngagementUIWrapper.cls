/**
* Created By : Madhura Priyadarshana
* Description : UI Wrapper to be used to manage both history(summary) and detail sections of contact history(member engagement)
* Date Created: 01/21/2021
*/
public without sharing class ADBMemEngagementUIWrapper{
    @AuraEnabled public List<History> histories;
    @AuraEnabled public String systemErrorMsg;
    
    public class History{
        @AuraEnabled public String openedDate;
        @AuraEnabled public String openedTime;
        @AuraEnabled public Long openedDateTime;
        @AuraEnabled public String closedDate;
        @AuraEnabled public String closedTime;
        @AuraEnabled public Long closedDateTime;
        @AuraEnabled public String createdBy;
        @AuraEnabled public String status;
        @AuraEnabled public String type;
        @AuraEnabled public String communication;
        @AuraEnabled public Integer engagementId;
    }
}