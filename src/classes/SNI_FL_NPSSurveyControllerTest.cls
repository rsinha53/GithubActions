//US3204124: This apex class will test SNI_FL_NPSSurveyController.apxc to determined wehther it is returning correct value
//Author Name : Ashley Winden
@isTest
public class SNI_FL_NPSSurveyControllerTest {
    @testsetup
    static void setupFamilyContacts(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test43252@test.optum.com.acet',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        
        System.runAs ( portalAccountOwner1 ) {
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            
            //Create account
            Account portalAccount1 = new Account(
                FirstName  = 'TestAccount1',
                LastName = 'Test 1',
                RecordTypeId = personAccRecordTypeId,
                OwnerId = portalAccountOwner1.Id,
                FamilyLink_Registration_Date__c = Date.today().AddDays(-15)
            );
            Database.insert(portalAccount1);
            
            Account portalAccount2 = new Account(
                FirstName = 'TestAccount2',
                LastName = 'Test 2',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccRecordTypeId,
                Phone = '1234567890',
                FamilyLink_Registration_Date__c = Date.today()
            );
            Database.insert(portalAccount2);
            
            List<Contact> conId = [SELECT id from contact where accountId =: portalAccount1.Id];
            
            //Create user
            Profile portalProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Care Advisor Connect Community User' Limit 1];
            
            User user1 = new User(
                Username = 'fltest1231231@optum.com.acet',
                ContactId = conId[0].Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
    }
    
  	@isTest
    static void getUserDetailValid(){
        Test.startTest();
        User u = [SELECT Id ,Email,contact.accountid from User where UserName='fltest1231231@optum.com.acet' LIMIT 1];
     	system.runAs(u){
        	System.assert(SNI_FL_NPSSurveyController.getUserDetail().FamilyLink_Registration_Date != null);
        	System.assert(SNI_FL_NPSSurveyController.getUserDetail().ErrorOccured == false);
        }
        Test.stopTest();
     }
}