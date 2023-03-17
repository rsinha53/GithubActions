public with sharing class ACET_FAST_ReopenNotificationController {
    public String caseId {
        get;
        set {
            caseId = value;
            if (caseId != null) {
                caseObj = [Select id,status, caseNumber,Case_Type__c, Owner.Name from case where id =:caseId];
                pirObj = [Select name, status__c,Reopen_Reason__c from PIR_Detail__c where case__c =:caseId ];

            }
            caseUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseId;
        }
    }
    public Case caseObj {get;set;}
    public PIR_Detail__c pirObj {get;set;}
    public String recipientName {get;set;}
    public String caseUrl {get;set;}
}