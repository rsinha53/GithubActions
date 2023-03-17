/********************************************************************************* 
Class Name     : SNI_FL_FamilyLookupControllerTest.apxc
Description    : Test Class for SNI_FLFamilyLookupController
Created By     : Pavithra Fernando
Created Date   : 8/27/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

----------------------------------------------------------------------------------            

*********************************************************************************/

@isTest
public class SNI_FL_FamilyLookupControllerTest {
    
    private static final String PGROUP = 'Provider Group';
    
    @testSetup static void setup() {
        Id familyRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        List<Account> acc = new List<Account>();
        acc.add(new Account(Name = 'Test Account' , RecordtypeId=familyRecordType, OwnerId=UserInfo.getUserId(), Phone = '123456789', Type = 'Prospect'));        
        acc.add(new Account(Name = 'Test Account123', RecordtypeId=familyRecordType, OwnerId=UserInfo.getUserId(), Phone = '123456789', Type = 'Prospect'));        
        acc.add(new Account(Name = 'Test Account321', RecordtypeId=familyRecordType, OwnerId=UserInfo.getUserId(), Phone = '123456789', Type = 'Prospect'));        
        insert acc; 
        
        List<AccountTeamMember> teams=new List<AccountTeamMember>();
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId =  acc[0].Id;
        atm.TeamMemberRole = 'Sales Assistant';
        atm.UserId = acc[0].OwnerId;
        teams.add(atm);
        insert teams;
    }

    @isTest
    static void fetchRecordsTest1() {
        
        List<Account> accList = [Select Id, OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Test', '', accList[0].OwnerId,'Family',null,true);
        System.assertEquals(result != null, true);
    }
    
 	@isTest
    static void fetchRecordsTest2() {
        
        List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Te', '', accList[0].OwnerId,'Family',null,true);
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsNegativeTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        	SNI_FL_FamilyLookupController.fetchRecords('', 'Name', 'Test', '', accList[0].OwnerId, 'Family',null,true);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
     @isTest
    static void fetchRecordsFamilyLevelTest1() {
        
        List<Account> accList = [Select Id, OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Test', '', accList[0].OwnerId,'Family',accList[0].Id,true);
        System.assertEquals(result != null, true);
    }
    
 	@isTest
    static void fetchRecordsFamilyLevelTest2() {
        
        List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Te', '', accList[0].OwnerId,'Family',accList[0].Id,true);
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsFamilyNegativeTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        	SNI_FL_FamilyLookupController.fetchRecords('', 'Name', 'Test', '', accList[0].OwnerId, 'Family',accList[0].Id,true);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    } 
    
    //Provider Group    
     @isTest
    static void fetchRecordsMemberLevelTest1() {        
        List<Account> accList = [Select Id, OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Test', '', accList[0].OwnerId,PGROUP,null,true);
        System.assertEquals(result != null, true);
    }
    
 	@isTest
    static void fetchRecordsMemberLevelTest2() {        
        List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Te', '', accList[0].OwnerId,PGROUP,null,true);
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsMemberLevelNegativeTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        	SNI_FL_FamilyLookupController.fetchRecords('', 'Name', 'Test', '', accList[0].OwnerId, PGROUP,null,true);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    
    //Provider Message - backup agent
   
     @isTest
    static void fetchRecordsProviderBackupTest1() {        
        List<Account> accList = [Select Id, OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Test', '', accList[0].OwnerId,PGROUP,null,false);
        System.assertEquals(result != null, true);
    }
    
 	@isTest
    static void fetchRecordsProviderBackupTest2() {        
        List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Te', '', accList[0].OwnerId,PGROUP,null,false);
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsProviderBackupNegativeTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        	SNI_FL_FamilyLookupController.fetchRecords('', 'Name', 'Test', '', accList[0].OwnerId, PGROUP,null,false);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    //Backup agents
    @isTest
    static void fetchRecordsBackupTest1() {
        
        List<Account> accList = [Select Id, OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Test', '', accList[0].OwnerId,'Family',null,false);
        System.assertEquals(result != null, true);
    }
    
 	@isTest
    static void fetchRecordsBackupTest2() {
        
        List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        List<SNI_FL_FamilyLookupController.RecordsData> result = SNI_FL_FamilyLookupController.fetchRecords('Account', 'Name', 'Te', '', accList[0].OwnerId,'Family',null,false);
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsBackupNegativeTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
        	SNI_FL_FamilyLookupController.fetchRecords('', 'Name', 'Test', '', accList[0].OwnerId, 'Family',null,false);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    @isTest
    static void familyPartnerTest() {
        try {
            List<Account> accList = [Select Id,OwnerId from Account where Phone= '123456789'];
            User u = [select Id from User where Id=:accList[0].OwnerId];
            Family_Partner__c  fampartner = new Family_Partner__c();
            fampartner.Family__c = accList[0].Id;
            fampartner.Partner__c = u.Id;
            insert fampartner;
        	SNI_FL_FamilyLookupController.fetchRecords('Family_Partner__c', 'Name', 'Test', '', accList[0].OwnerId, 'Family',null,false);
        	SNI_FL_FamilyLookupController.fetchRecords('Family_Partner__c', 'Name', 'T', '', accList[0].OwnerId, 'Family',null,false);
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
   
}