/*
**********************************************************************************
Class Name:  ACETUpdateACRRelationshipBatch
Description : To update the relation,memberId,PolicyId from account to account contact relationship
Author: Priyanka 
Created Date : 28-02-2020
Modification History :
**********************************************************************************
*/     
global class ACETUpdateACRRelationshipBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Id familyRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        return Database.getQueryLocator('Select Id,Account.Member_ID__c,Account.Policy_ID__c,contact.Relationship__c,Relationship__c,Policy_ID__c,Member_ID__c From AccountContactRelation where Account.recordtypeid =: familyRecordtypeId ');    
    }
    global void execute(Database.BatchableContext BC, List<AccountContactRelation> scope) {
        List<AccountContactRelation> acrUpdateList = new List<AccountContactRelation>();
        String relationship ;
        Map<String,String> relationshipMap = ACETUtility.getHouseholdRelationshipMap();
        List<String> unknownrelations = new List<String>();
        try{
            for(AccountContactRelation acr : scope){
                acr.Member_ID__c = acr.Account.Member_ID__c;
                acr.Policy_ID__c = acr.Account.Policy_ID__c;
                if(relationshipMap.get(acr.contact.Relationship__c) != null){
                relationship = relationshipMap.get(acr.contact.Relationship__c);
                }
                else{
                    unknownrelations.add(acr.contact.Relationship__c);
                    relationship = 'Unknown';
                }
                acr.Relationship__c = relationship;
                acrUpdateList.add(acr);
            }
            for(String s :unknownrelations){
                ACETUtility.insertHouseholdRelationshipData(s);
            }
            if(acrUpdateList.size()>0){
                Update acrUpdateList;
            }
            
        }catch(Exception e){
            
        }
    }
    global void finish(Database.BatchableContext BC) {}
    
}