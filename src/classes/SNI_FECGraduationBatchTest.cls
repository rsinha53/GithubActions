@isTest
public class SNI_FECGraduationBatchTest {
    
    /*
     * Created by: Eagles - Bobby Culbertson
     * Date: 4/15/2021
     * User Story - US3277905  
     */
    private static final String familyRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
    private static final String personRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    
    @TestSetup static void setup(){
        User oUser = [select id,contactid, Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        List<Account> familyList = TestDataFactory.createBulkAccounts();
        List<Account> personList = new List<Account>();
        List<Family_Overview__c> familyOverviewList = new List<Family_Overview__c>();
        
        String familyRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        String personRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Integer idKey = 1;
        for(Account a :familyList){
            a.RecordTypeId = familyRecordType;
            a.Member_Id__c = '1231234567'+String.valueOf(idKey);
            a.OwnerId = oUser.Id;
            
            
            Family_Overview__c fam=new Family_Overview__c();
            fam.Account__c=a.Id;
            if(idKey == 1){
                fam.Designation__c = 'Assigned';
                fam.Family_Status__c = 'Inactive';
                fam.Last_Active_Date__c = (Date.today() - 385);
            } else if(idKey == 2){
                fam.Designation__c = 'Assigned';
                fam.Family_Status__c = 'Inactive';
                fam.Last_Active_Date__c = (Date.today() - 200);
            } else if(idKey == 3){
                fam.Designation__c = 'Deferred';
                fam.Designation_Changed_Date__c = (Date.today() - 200);
                fam.Last_Active_Date__c = (Date.today() - 200);

            } else if(idKey == 4){
                fam.Designation__c = 'Deferred';
                fam.Designation_Changed_Date__c = (Date.today() - 100);
                fam.Last_Active_Date__c = (Date.today() - 100);
            } else {
                fam.Family_Status__c='Active';
            }
            fam.Exception__c = 'No';
            fam.Family_Needs__c='Low';
            fam.UHG_Restriction__c='No';
            fam.Onshore_Restriction__c='No';
            familyOverviewList.add(fam);
            idKey++;
        }
        
        update familyList;
        insert familyOverviewList;
        
        for(integer i = 0; i<10; i++){
            Account accountTest = new Account();
            accountTest.FirstName = 'Luke';
            accountTest.LastName = 'Testwalker'+String.valueOf(i);
            accountTest.EID__c = 'lukeTestwalker'+String.valueOf(i)+'@testEmail.com';
            accountTest.RecordTypeId = personRecordType;
            personList.add(accountTest);
        }
        
        insert personList;
        
        List<Contact> contactList = [SELECT ID, AccountId From Contact WHERE AccountId != null LIMIT 10];
  
    }
    
    private static String createAcr(){
        String manyMemberFamilyId;
        List<Contact> contactList = [Select Id From Contact];
        List<Account> familyList = [Select Id From Account Where RecordTypeId = :familyRecordType];
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        for(integer i = 0; i<10; i++){
            AccountContactRelation acr = new AccountContactRelation();
            //need a couple of contacts to be in same family, so attaching first two contacts to same family id
            if(i<2){
                acr.AccountId = familyList[0].Id;
                if(String.isBlank(manyMemberFamilyId)){
                    manyMemberFamilyId = familyList[0].Id;
                }
            } else {
                acr.AccountId = familyList[i].Id;
            }
            acr.ContactId = contactList[i].Id;
            
            acrList.add(acr);
        }
        
        insert acrList;
        
        
        return manyMemberFamilyId;
    }
    
    public testmethod static void testBatchOpenCases(){
        String manyMemberFamilyId = createAcr();
        Account person1 = [Select Id From Account Where RecordTypeId = :personRecordType LIMIT 1];
        Id ecmRecordType = [SELECT Id FROM RecordType WHERE Name = 'ECM' LIMIT 1].remove(0).Id;
        Case case1 = new Case (
            AccountId = person1.Id,
            Status = 'Open',
            RecordTypeId = ecmRecordType,
            Case_Type__c = 'Opportunity'
        );
        
        insert case1;
        Test.startTest();
        Database.executeBatch(new SNI_FECGraduationBatch());        
        Test.stopTest();
        Contact c1 = [Select Id FROM Contact WHERE AccountId = :person1.Id LIMIT 1];
        AccountContactRelation acr1 = [Select Id, AccountId FROM AccountContactRelation WHERE ContactId = :c1.Id LIMIT 1];
        Family_Overview__c fo1 = [Select Id, Designation__c, Family_Status__c FROM Family_Overview__c WHERE Account__c = :acr1.AccountId LIMIT 1];
        Family_Overview__c fo2 = [Select Id, Designation__c, Family_Status__c FROM Family_Overview__c WHERE Account__c != :acr1.AccountId LIMIT 1];
        system.assertEquals('Active' ,fo1.Family_Status__c);
        system.assertEquals('Inactive' ,fo2.Family_Status__c);
    }
    public testmethod static void testBatchManyOpenCases(){
        String manyMemberFamilyId = createAcr();
        Date myDate = (Date.today() -100);
        Family_Overview__c fo = [Select Id, Account__c From Family_Overview__c 
                                 WHERE Exception__c = 'No' 
                                 AND Designation__c = 'Deferred' 
                                 AND Designation_Changed_Date__c = :myDate 
                                 AND Last_Active_Date__c = :myDate LIMIT 1];
        AccountContactRelation acr = [Select ID, AccountId, ContactId, Contact.AccountId From AccountContactRelation WHERE AccountId = :fo.Account__c LIMIT 1];
        
        Account person1 = [Select Id From Account Where ID = :acr.Contact.AccountId LIMIT 1];
        Id ecmRecordType = [SELECT Id FROM RecordType WHERE Name = 'ECM' LIMIT 1].remove(0).Id;
        List<Case> newCases = new List<Case>();
        for(Integer i=0; i<4; i++){
            Case case1 = new Case (
                AccountId = person1.Id,
                Status = 'Open',
                RecordTypeId = ecmRecordType,
                Case_Type__c = 'Opportunity'
            ); 
            newCases.add(case1);
        }

        insert newCases;
        Test.startTest();
        Database.executeBatch(new SNI_FECGraduationBatch());        
        Test.stopTest();
        Family_Overview__c newFO = [Select Id, Designation__c FROM Family_Overview__c WHERE ID = :fo.Id LIMIT 1];
        System.assertEquals('Assigned', newFO.Designation__c);
    }
    
    public testmethod static void testBatchProactive(){
        String manyMemberFamilyId = createAcr();
        Account person1 = [Select Id From Account Where RecordTypeId = :personRecordType LIMIT 1];
        
        Id proactiveRT = [SELECT Id FROM RecordType WHERE Name = 'Proactive Alert' LIMIT 1].remove(0).Id;
        Case case1 = new Case (
            AccountId = person1.Id,
            Status = 'New',
            RecordTypeId = proactiveRT
        );
        
        insert case1;
        Test.startTest();
        Database.executeBatch(new SNI_FECGraduationBatch());        
        Test.stopTest();
        Contact c1 = [Select Id FROM Contact WHERE AccountId = :person1.Id LIMIT 1];
        AccountContactRelation acr1 = [Select Id, AccountId FROM AccountContactRelation WHERE ContactId = :c1.Id LIMIT 1];
        Family_Overview__c fo1 = [Select Id, Designation__c, Family_Status__c FROM Family_Overview__c WHERE Account__c = :acr1.AccountId LIMIT 1];
        Family_Overview__c fo2 = [Select Id, Designation__c, Family_Status__c FROM Family_Overview__c WHERE Account__c != :acr1.AccountId LIMIT 1];
        system.assertEquals('Active' ,fo1.Family_Status__c);
        system.assertEquals('Inactive' ,fo2.Family_Status__c);
    }
    
    public testmethod static void testTask(){
        String manyMemberFamilyId = createAcr();
        
        Set<Id> personIds = new Set<Id>();
        List<AccountContactRelation> acrList = [Select Id, ContactId, Contact.AccountId From AccountContactRelation WHERE AccountId = :manyMemberFamilyId];
        for(AccountContactRelation a : acrList){
            personIds.add(a.Contact.AccountId);
        }
        
        List<Account> personList = [Select Id From Account WHERE ID IN :personIds];
        Id sensRecordType = [SELECT Id FROM RecordType WHERE Name = 'SENS Task'LIMIT 1].remove(0).Id;
        List<Task> newTasks = new List<Task>();
        
        for(Account a : personList){
            system.debug('--BOBBY--account id to make tasks: '+a.Id);
            Task task1 = new Task (
                WhatId = a.Id,
                Status = 'In Progress',
                RecordTypeId = sensRecordType, 
                Subject = 'Care Advisor Connect Response'
            );
            newTasks.add(task1);
        }
        Task famTask = new Task(
            WhatId = manyMemberFamilyId,
            Status = 'In Progress',
            RecordTypeId = sensRecordType, 
            Subject = 'Care Advisor Connect Response'
        );
        newTasks.add(famTask);
        
        insert newTasks;
        Test.startTest();
        Database.executeBatch(new SNI_FECGraduationBatch());        
        Test.stopTest();
        
    }
}