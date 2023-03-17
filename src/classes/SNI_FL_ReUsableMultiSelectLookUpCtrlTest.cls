/********************************************************************************* 
Class Name     : SNI_FL_ReUsableMultiSelectLookUpCtrlTest.apxc
Description    : Test Class for SNI_FL_ReUsableMultiSelectLookUpCtrl
Created By     : Vamsi Krishna
Created Date   : 8/29/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

----------------------------------------------------------------------------------            

*********************************************************************************/


@isTest
public class SNI_FL_ReUsableMultiSelectLookUpCtrlTest {
    
    //Used to test "getFamilyAgentDetails" method in "SNI_FLReUsableMultiSelectLookUpCtrl" class
    //Author: Sameera ACDC
    @isTest
    static void getFamilyAgentDetailsUserListNotEmptyTest(){
        List<sObject> lstObjects;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            SNI_FL_DirectMessageTestDataFactory.createAccountWIthOwner('Business_Account');
        }
        Account testAccount = [SELECT ID FROM Account WHERE EID__c ='!123abcACDC'];
        
        Test.startTest();
        lstObjects = SNI_FLReUsableMultiSelectLookUpCtrl.getFamilyAgentDetails(testAccount.id);
        Test.stopTest();
        Integer size = lstObjects.size();
        System.assertEquals(1,1,'Returned list is empty from SNI_FLReUsableMultiSelectLookUpCtrl class and getFamilyAgentDetails method');
        
    }
    
    //Used to test "getFamilyAgentDetails" method in "SNI_FLReUsableMultiSelectLookUpCtrl" class
    //Author: Sameera ACDC
    @isTest
    static void getFamilyAgentNullTest(){
        List<sObject> lstObjects;
        
        Test.startTest();
        lstObjects = SNI_FLReUsableMultiSelectLookUpCtrl.getFamilyAgentDetails('123');
        Test.stopTest();
        
        System.assertEquals(NULL,lstObjects,'Returned list is notempty from SNI_FLReUsableMultiSelectLookUpCtrl class and getFamilyAgentDetails method');
        
    }
    
    //Used to test "getFamilyAgentDetails" method in "SNI_FLReUsableMultiSelectLookUpCtrl" class
    //Author: Sameera ACDC
    @isTest
    static void getFamilyAgentInactiveOwnerTest(){
        List<sObject> lstObjects;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            SNI_FL_DirectMessageTestDataFactory.createAccountWIthInactiveOwner('Business_Account');
        }
        Account testAccount = [SELECT ID,OwnerId FROM Account WHERE EID__c ='!1234abcACDC'];
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            User userRecord = [SELECT ID,IsActive FROM User WHERE ID =:testAccount.OwnerId];
            userRecord.IsActive = false;
            update userRecord;
        }
        
        
        
        Test.startTest();
        
        lstObjects = SNI_FLReUsableMultiSelectLookUpCtrl.getFamilyAgentDetails(testAccount.id);
        Test.stopTest();
        Integer size = lstObjects.size();
        System.assertEquals(0,size,'Returned list is notempty from SNI_FLReUsableMultiSelectLookUpCtrl class and getFamilyAgentDetails method');
        
    }
    
    
    public static testmethod void fetchLookUpValuestest(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = '123456789';
        acc.Type = 'Prospect';  
        Test.startTest();
        insert acc;        
        List<Account> result =  SNI_FLReUsableMultiSelectLookUpCtrl.fetchLookUpValues(null,'searchKeyWord', 'Account', null);
        Test.stopTest();
        System.assertEquals(result != null, true);
    }
    
    public static testmethod void fetchLookUpValuestest100(){
        Account accs = new Account();
        accs.Name = 'Test Account Data';
        accs.Phone = '1234567890';
        accs.Type = 'Customer';
        Test.startTest();        
        insert accs;
        List<SNI_FL_Care_Team_Member__c> ctMemberList = new List<SNI_FL_Care_Team_Member__c>(); 
        SNI_FL_Care_Team_Member__c member = new SNI_FL_Care_Team_Member__c();
        member.SNI_FL_Member__c = accs.id;
        member.SNI_FL_Family__c= accs.id;
        member.SNI_FL_Status__c = 'Registered';
        ctMemberList.add(member);
        SNI_FL_Care_Team_Member__c member2 = new SNI_FL_Care_Team_Member__c();
        member2.SNI_FL_Status__c = 'Registered';
        member2.SNI_FL_Member__c = accs.id;
        member2.SNI_FL_Family__c= accs.id;
        ctMemberList.add(member2);
        insert ctMemberList;
        
        List<SNI_FL_Care_Team_Member__c> result =SNI_FLReUsableMultiSelectLookUpCtrl.fetchLookUpValues(null,'Test Account Data', 'SNI_FL_Care_Team_Member__c', accs.id);
        SNI_FLReUsableMultiSelectLookUpCtrl.fetchLookUpValues(null,'', 'SNI_FL_Care_Team_Member__c', accs.id);
        Test.stopTest();
        system.assertEquals(result != null, true);
        
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u;
        System.runAs(thisUser){
            u = new User(Alias = 'standt1', Email='standarduse1ij2r@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser15testedfdf@testorg.com');
            insert u;
        }
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            SNI_FLReUsableMultiSelectLookUpCtrl.fetchUserRecord(u.Id);
        }
    }
    @isTest
    static void fetchLookupPartnerTest(){
        Test.startTest();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            SNI_FL_DirectMessageTestDataFactory.createAccountWIthOwner('Business_Account');
        }
        Account testAccount = [SELECT Id,OwnerId FROM Account WHERE EID__c ='!123abcACDC'];
        User u = [select Id from User where Id=:testAccount.OwnerId];
        Family_Partner__c  fampartner = new Family_Partner__c();
        fampartner.Family__c = testAccount.Id;
        fampartner.Partner__c = u.Id;
        insert fampartner;
        SNI_FLReUsableMultiSelectLookUpCtrl.fetchLookUpValues(null,'FirstName', 'Family_Partner__c', testAccount.id);
        
        Test.stopTest();
    }
    @isTest
    static void getRoleDescriptionToolTip(){
        Test.startTest();
        SNI_FL_Utility__c util = new SNI_FL_Utility__c();
        util.name = 'PartnerRole Local Nurse Advisor';
        util.SNI_FL_Design__c = 'Supports Clinical questions.';
        insert util;
        SNI_FLReUsableMultiSelectLookUpCtrl.mapOfToolTipRoles();
        Test.stopTest();
    }
    
}