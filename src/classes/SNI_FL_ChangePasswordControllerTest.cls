/**
* Author: Team Eagles
* Description: An apex page controller that exposes the change password functionality
* Date Modified: 08/12/2020
*/
@IsTest public with sharing class  SNI_FL_ChangePasswordControllerTest {
    
    @testsetup
    static void prepareTestData() {
        Id roleId = [SELECT Id from UserRole WHERE Name = 'Care advisor' LIMIT 1].Id;
        user careAdvsior;
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        careAdvsior = new User(Alias = 'standt1', Email='admin@testorg1.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p1.Id,userRoleId = roleId, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='admin1@acettest.com');
        insert careAdvsior;
        AccountContactRelation acr = new AccountContactRelation();
        system.runAs(new user(Id = careAdvsior.Id)){
    
            // Creating and Inserting Family Account
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Account ac = new Account();
            ac.Member_ID__c = '453543543';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'SampleTEstFLAcc1';
            ac.RecordTypeId = recordTypeId;
            ac.ownerId = careAdvsior.id;
            insert ac;
            
            // Creating and Inserting PersonAccount
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'paLastSample1'; 
            pa.lastName = 'paFirstSample1'; 
            pa.RecordTypeId = personAccRecordTypeId;
            insert pa;
            
            //Creating ACR with Person and Family
            account pa1 = [select id,personcontactid from account where id =: pa.id];
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            acr.Member_ID__c='12354';
            insert acr;
            
        }
        system.runAs(new user(Id = userinfo.getUserId())){
            //Creating test User
            Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
            User u = new User(Alias = 'standt', Email='admin@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='admin@acettest.com');
            u.ContactId = acr.ContactId;
            Insert u;
        }
    }
    
    
    @IsTest public static void testcorrectPasswords() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            Test.startTest();
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();
            
            controller.newPassword = '12345678@a';
            
            controller.verifyNewPassword = '12345678@a';
            
            System.assertEquals(controller.doAction(),null);
            Test.stopTest();
        }
    }
    @IsTest public static void testpasswordslength() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        AccountContactRelation acr2 = [SELECT Id,Member_ID__c,Account.Alternate_id__c FROM AccountContactRelation WHERE Relationship__c = 'Child/Other'];
        System.runAs(u) {
            Test.startTest();
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();
            
            controller.newPassword = '12345';
            
            controller.verifyNewPassword = '12345';
            controller.doAction();
            
           // System.assertEquals(controller.msg,'Passwords must be at least eight characters with a minimum of one number, one letter, and one special character.');
            Test.stopTest();
        }
    }
    
    @IsTest public static void testpasswordsmismatch() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            Test.startTest();
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();
            
            controller.newPassword = '12345';
            
            controller.verifyNewPassword = '12345789@';
            controller.doAction();
            //System.assertEquals(controller.msg,'Please confirm the passwords match and try again.');
            Test.stopTest();
        }
    }
    
    @IsTest public static void testpasswordsempty() {
        User u = [SELECT Id FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            Test.startTest();
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();
            
            controller.newPassword = '';
            
            controller.verifyNewPassword = '';
            controller.doAction();
           // System.assertEquals(controller.msg,'Please enter a value in the Password fields.');
            Test.stopTest();
        }
    }
    
    @IsTest public static void testCheckTitlechangePassword() {
        User u = [SELECT Id, ContactId FROM User WHERE Email='admin@testorg.com'];
        Account acc = [SELECT id FROM Account WHERE personcontactid =: u.ContactId];
        acc.FamilyLink_Registration_Date__c = Date.newInstance(2020, 03, 08);
        update acc;
        System.runAs(u) {
            Test.startTest();
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();
            System.assertEquals(controller.pageTitle, 'Change Your Password');
            Test.stopTest();
        }
        
    }
    
    @IsTest public static void testMemberID() {
        User u = [SELECT Id, ContactId FROM User WHERE Email='admin@testorg.com'];
        System.runAs(u) {
            Test.startTest();
            
            SNI_FL_ChangePasswordController controller = new SNI_FL_ChangePasswordController();  
            controller.newPassword = '';
            controller.verifyNewPassword = '';
            controller.memberID = '123';
            controller.doAction();
            //controller.redirectForMembers();
            SNI_FL_ChangePasswordController.removePrecedingZeros('test');
            //System.assertEquals(controller.msg1, 'The Member ID that was entered is incorrect, please enter a valid Member ID. If you are having trouble, please contact your Family Advisor by calling the number on the back of your insurance card.');
            Test.stopTest();
        }
    }
    
    
}