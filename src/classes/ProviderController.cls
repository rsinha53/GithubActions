/********************************************************************************* 
Class Name     : ProviderController.apxc
Description    : Provider Dashboard navigation menu 
Created By     : Karthik 
Created Date   : 11/19/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Karthik			        11/19/2020				Created class without body
----------------------------------------------------------------------------------            

*********************************************************************************/
public  without sharing class ProviderController {
    @AuraEnabled
    public static ProviderWrapper getUserData() {
        
        ID proAffRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Id contactId = [SELECT id, contactid FROM user WHERE id = :userinfo.getuserid()].contactId;
        
        Set<Id> affiliationIds = new Set<Id>();
        for(AccountContactRelation acrRecords : [SELECT id, accountid FROM AccountContactRelation WHERE contactid = :contactId]) {
            affiliationIds.add(acrRecords.accountId);
        }
        
        List<Provider_Affiliation> lstOptions = new List<Provider_Affiliation>();
        List<String> sortingList = new List<String>();
        Map<String, Account> proAffMap = new Map<String, Account>();
        
        for(Account accRecord : [SELECT Id, Population__c, Program__r.Program__c FROM account WHERE Id IN :affiliationIds AND RecordTypeId = :proAffRecordTypeId]) {
            String value =  accRecord.Program__r.Program__c + ' - ' + accRecord.Population__c + accRecord.Id;
            proAffMap.put(value, accRecord);
            sortingList.add(value);
        }
        sortingList.sort();
        for(String sortRecord : sortingList) {
            Account acc = proAffMap.get(sortRecord);
            String value =  acc.Program__r.Program__c + ' - ' + acc.Population__c ;
            lstOptions.add(new Provider_Affiliation(value, acc.Id));
        }
        
        ProviderWrapper proWrapper = new ProviderWrapper();
        
        proWrapper.userName = UserInfo.getName();
        proWrapper.Id = UserInfo.getUserId();
        proWrapper.affliations = lstOptions;
        
        return proWrapper;
        
    }
    
    public class ProviderWrapper {
        @AuraEnabled public String userName {get;set;}
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public List<Provider_Affiliation> affliations{get;set;}
    }
    
    // Store ProviderAffiliation Related Data
    public class Provider_Affiliation{
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String id{get;set;}
        
        public Provider_Affiliation(String value,String id){
            this.value = value;
            this.id = id;
        }
    }

    //Team AC/DC Mark With New Icon when a New Message is Received
    @AuraEnabled
    public static Boolean markNewMessageIcon(String userIdValue){
        try { 
            Boolean isAvailableNewMessages;               
            List <SNI_FL_Message_Notification__c> lstUsers = [SELECT Id,Name, FeedId__c, MessageDate__c,RecipientId__c,SenderId__c FROM SNI_FL_Message_Notification__c WHERE RecipientId__c =: userIdValue AND IsViewed__c = false AND SenderId__c !=: userIdValue ]; //
            if(lstUsers != null && !lstUsers.isEmpty()){
                isAvailableNewMessages = true;
            }else{
                isAvailableNewMessages = false;
            }
            return isAvailableNewMessages;
        } catch(exception ex) {
            System.debug('ACDC Exception markNewMessageIcon '+ex.getMessage()+'Line '+ex.getLineNumber());
            return null; 
        } 
    }
    
    //Team AC/DC Delete Read Messages from SNI_FL_Message_Notification__c
    @AuraEnabled
    public static void deleteReadMessages(String userIdValue){
        try { 
            List<SNI_FL_Message_Notification__c> lstUsers = [SELECT Id,Name, FeedId__c, MessageDate__c,RecipientId__c,SenderId__c FROM SNI_FL_Message_Notification__c WHERE RecipientId__c =: userIdValue AND IsViewed__c = false]; 
            if(lstUsers != null && !lstUsers.isEmpty()){
                delete lstUsers; 
            }            
        } catch(exception ex) {
            System.debug('ACDC Exception deleteReadMessages '+ex.getMessage()+'Line '+ex.getLineNumber());
            
        } 
    }
}