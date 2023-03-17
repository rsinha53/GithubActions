global with sharing class ACETDeleteResearchInteractionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(!test.isRunningTest()){
            return Database.getQueryLocator('Select Id From Interaction__c WHERE Interaction_Type__c = \'Research Only\'');
        }else{
            return Database.getQueryLocator('Select Id From Interaction__c WHERE Interaction_Type__c = \'Research Only\' limit 100');
        }    
    }
   
    global void execute(Database.BatchableContext BC, List<Interaction__c> scope) {
        if(Interaction__c.sObjectType.getDescribe().isDeletable()){
          Database.Delete(scope, false);
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
    
}