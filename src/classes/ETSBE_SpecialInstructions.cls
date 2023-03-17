public with sharing class ETSBE_SpecialInstructions {
    
    @AuraEnabled public String businessUnit {get;set;}
    @AuraEnabled public String topic {get;set;}
    @AuraEnabled public String type {get;set;}
    @AuraEnabled public String subtype {get;set;}
    @AuraEnabled public String urlEmail {get;set;}
    @AuraEnabled public String formLink {get;set;}
    @AuraEnabled public String directions {get;set;}
    @AuraEnabled public String slaDay {get;set;}
    @AuraEnabled public String routingOptions {get;set;}
    @AuraEnabled public String departmentDesc {get;set;}
    @AuraEnabled public Boolean dosRequired {get;set;}
    @AuraEnabled public String queueName {get;set;}
    @AuraEnabled public String sfId {get;set;}
    @AuraEnabled public String acetTopic {get;set;}
    @AuraEnabled public String acetType {get;set;}
    @AuraEnabled public String acetSubtype {get;set;}
    @AuraEnabled public String valOnRoutedAppl {get;set;}
    @AuraEnabled public String routingApplDesc {get;set;}
    @AuraEnabled public Boolean isCDX {get;set;} 
    @AuraEnabled public String MemberIDRequiredIndicator {get;set;} 

}