/**
* Author: Abhinav Balla
* Date Created: 10/22/2020
* Date Modified:
* Purpose: To Capture the request needed for the service
* 
**/
public class ADBFollowUpHistoryRequestWrapper {
    
        @AuraEnabled
        public ControlModifiers controlModifiers;
        @AuraEnabled
        public String issueId;
    
    public class ControlModifiers {
        @AuraEnabled
        public OrsSystemParameters orsSystemParameters;
    }
    
    public class OrsSystemParameters {
        @AuraEnabled
        public String logonId;
        @AuraEnabled
        public String logonOffice;
    }
}