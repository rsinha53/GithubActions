@isTest
public class SNI_FL_WelcomeScreenControllerTest {
    
    @TestSetup
    static void makeData(){
        
        Date dob = Date.parse('10/29/1970');
        Id personRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Family Digital Onboardng';
        insert acc;
        Account personUser = new Account(
            Salutation = 'Mr.',
            FirstName = 'digitali',
            LastName = 'onboard4',
            PersonEmail = 'yarrodigitalonb1@optum.com.acet',
            RecordTypeId = personRTId
        );
        insert personUser;
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Designation__c = 'Assigned';
        fo.Account__c = acc.id;
        insert fo;
        
        account pa1 = [select id,personcontactid from account where id =: personUser.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        List<User> userList = new List<User>();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Community User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarroDOb';
            user.LastName = 'yevvanohe';
            user.Username = 'ABCD1234DOb@optum.com.acet';
            user.CommunityNickname = 'testUser123Dob';
            user.Alias = 't12';
            user.Email = 'noyarroDOb@optum.com.acet';
            user.IsActive = true;
            user.ContactId = pa1.personcontactid;
            userList.add(user);
            User user1 = new User();
            user1.ProfileID = [Select Id From Profile Where Name='System Administrator'].id;
            user1.EmailEncodingKey = 'ISO-8859-1';
            user1.LanguageLocaleKey = 'en_US';
            user1.TimeZoneSidKey = 'America/New_York';
            user1.LocaleSidKey = 'en_US';
            user1.FirstName = 'yarroDOb';
            user1.LastName = 'yevvanohe';
            user1.Username = 'XYZ1234DOb@optum.com.acet';
            user1.CommunityNickname = 'testUser123XYZ';
            user1.Alias = 't12';
            user1.Email = 'XYZ1234DOb@optum.com.acet';
            user1.IsActive = true;
            userList.add(user1);
            insert userList;
        }
        
    }
    
    public static testMethod void testGetAdvisor() {
        User u = [SELECT Id FROM User Where Username = 'ABCD1234DOb@optum.com.acet' LIMIT 1];
        System.runAs(u){
            Test.startTest();
            User advisor = SNI_FL_WelcomeScreenController.getAdvisor();
            System.assert(advisor != null);
            Test.stopTest();
        }
    }
    
    public static testMethod void testGetPerson() {
        User u = [SELECT Id FROM User Where Username = 'ABCD1234DOb@optum.com.acet' LIMIT 1];
        System.runAs(u){
            Test.startTest();
            Account person = SNI_FL_WelcomeScreenController.getPerson();
            System.assert(person != null);
            Test.stopTest();
        }
    }
    
    public static testMethod void testNegatives() {
        User u = [SELECT Id FROM User Where Username = 'XYZ1234DOb@optum.com.acet' LIMIT 1];
        System.runAs(u){
            Test.startTest();
            Account person = SNI_FL_WelcomeScreenController.getPerson();
            System.assert(person == null);
            User advisor = SNI_FL_WelcomeScreenController.getAdvisor();
            System.assert(advisor == null);
            Test.stopTest();
        }
    }
}