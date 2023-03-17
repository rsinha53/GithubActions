@isTest
public class SNI_FL_WelcomeMsg_NotificationTest {
    @testSetup static void testSetupData() {
       
        //Create Person Account 1
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        pa.Email_Notification__c =true;
        update pa;
        
        //Create Person Account 2
        Account pa1 =new account();
        pa1.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa1.firstName = 'Community'; 
        pa1.lastName = 'FLTestUser'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        pa1.Email_Notification__c =true;
        update pa1;
       
       //Create Users
       List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
       List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name = 'Care Advisor Connect Community User']; 
         User usr = new User(
            LastName = 'testP',
            FirstName='testP',
            Alias = 'tp',
            Email = 'abc191@optum.com',
            Username = 'abc191@optum.com',
            profileId=pList[0].Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ContactId = conId[0].Id,
            LocaleSidKey = 'en_US',
            Agent_Type__c='Offshore',
            MobilePhone='(202)795-3213'
        );
        List<Contact> conId1 = [SELECT id from contact where accountId =: pa1.Id];
        User usr1 = new User(
            LastName = 'testP1',
            FirstName='testP1',
            Alias = 'tp',
            Email = 'abcd192@optum.com',
            Username = 'abcd192@optum.com',
            profileId=pList[0].Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ContactId = conId1[0].Id,
            LocaleSidKey = 'en_US',
            Agent_Type__c='Offshore',
            MobilePhone='(202)795-3214'
        );
        List<user> ulist = new List<user>();
        ulist.add(usr);
        ulist.add(usr1);
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert ulist; }
    }
    @isTest static void sendSMSNotificationsTest() {
       Test.startTest();
       List<User> ulist = [Select Id from User where LastName like 'testp%'];
       Set<Id> userIdSet = new Set<Id>();
       for(User u : ulist) {
           userIdSet.add(u.id);
        }
      SNI_FL_WelcomeMsg_Notification.sendSMSNotifications(userIdSet);
      Test.stopTest();
    }
    
}