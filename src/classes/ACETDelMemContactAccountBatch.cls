global with sharing class ACETDelMemContactAccountBatch implements Database.Batchable<sObject> {
    public Datetime previousDt {get;set;}
    public void ACETDelMemContactAccountBatch(){
        previousDt = Datetime.now().addHours(-24);
        system.debug('previousDt-->'+previousDt);       
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id From Interaction__c WHERE CreatedDate <: previousDt AND ID Not IN(Select Interaction__c from Case)');    
    }
   
    global void execute(Database.BatchableContext BC, List<Interaction__c> scope) {
        Database.Delete (scope);
    }   
    
    global void finish(Database.BatchableContext BC) {
        list<Contact> delContact = [Select Id From Contact WHERE CreatedDate <: previousDt AND  RecordType.Name = 'Member' AND ID Not IN(Select ContactId from Case) AND ID Not IN(Select Originator__c from Interaction__c)];
        if(delContact != null && !delContact.isEmpty())
            Database.Delete (delContact);
        //list<Account> delAccount = 
        list<id> accountId = new list<Id>();
        for(Account varAcc : [Select Id From Account WHERE CreatedDate <: previousDt AND ID Not IN(Select AccountId from Contact) AND ID NOT IN(Select AccountId from Case)]){
            accountId.add(varAcc.Id);       
        }
        list<Account> delAccount = [Select Id From Account WHERE ID Not IN(Select AccountId from Entitlement) AND ID IN :accountId];
        if(delAccount != null && !delAccount.isEmpty())
            Database.Delete (delAccount);
    }



}