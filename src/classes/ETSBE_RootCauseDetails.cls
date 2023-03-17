public with sharing class ETSBE_RootCauseDetails {
    @AuraEnabled public String issueCategory {get;set;}
    @AuraEnabled public String defectType {get;set;}
    @AuraEnabled public String rootCauseIssueCategory {get;set;}
    @AuraEnabled public String rootCause {get;set;}
    @AuraEnabled public String briefDesc {get;set;}
    @AuraEnabled public String serviceImpactDate{get;set;}
    @AuraEnabled public String businessUnit{get;set;}
}