public without sharing class FIMResultWrapper {
    
    @AuraEnabled public Integer fimResponseCode{get;set;}
    @AuraEnabled public String callerSSN{get;set;}
    @AuraEnabled public String callerHomeState{get;set;}
    @AuraEnabled public String memberId{get;set;}
}