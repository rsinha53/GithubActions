/**
* Author: Hasara Disanayaka
* Date Created: 31/03/2020
* Date Modified:
* Purpose: To Capture the request needed for the service
* 
**/
public without sharing class ADBReadIssueDetailsRequestWrapper {
    
    @AuraEnabled public ControlModifiers controlModifiers{ get; set; }
    @AuraEnabled public String issueId{ get; set; }
    public class ControlModifiers {
        @AuraEnabled public OrsSystemParameters orsSystemParameters{ get; set; }
    }
     public class OrsSystemParameters {
        @AuraEnabled public String logonId{ get; set; }
        @AuraEnabled public String logonOffice{ get; set; }
    }
}