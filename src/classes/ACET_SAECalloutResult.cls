public with sharing class ACET_SAECalloutResult {
    @AuraEnabled public Boolean isSuccess {get;set;}
    @AuraEnabled public Integer statusCode {get;set;}
    @AuraEnabled public Object response {get;set;}
    @AuraEnabled public String message {get;set;}
    @AuraEnabled public ApexPages.Severity messageSeverity {get;set;}
}