@isTest
public  class ACETUserTriggerHandlerTest 
{   
   static testMethod void ACETUserTriggerHandlerTestMethod1()
  {  
        Test.startTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
        UserRole ur =[SELECT Id FROM UserRole WHERE Name='Billing - Supervisor - Offshore' LIMIT 1];
        User usr = new User(LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                           Email = 'aceagenttest6677656@ac.com',
                           Username = 'aceagenttest6677656@ac.com',
                           profileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Onshore',
                           UserRoleId = ur.id);
        insert usr;
        usr.Agent_Type__c='Offshore';
        update usr;
        
        ACETUserTriggerHandler  AUTH = new ACETUserTriggerHandler();
       // AUTH.addUserToGroup();
    
        Test.stopTest();
  }
  static testMethod void ACETUserTriggerHandlerTestMethod2()
  {  
        Test.startTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
         UserRole ur =[SELECT Id FROM UserRole WHERE Name='Billing - Supervisor - Offshore' LIMIT 1];
        User usr = new User(LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                           Email = 'aceagenttest6677656@ac.com',
                           Username = 'aceagenttest6677656@ac.com',
                           profileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Offshore',
                           UserRoleId = ur.Id);
        insert usr;
        usr.Agent_Type__c='Onshore';
        update usr;
        
        ACETUserTriggerHandler  AUTH = new ACETUserTriggerHandler();
       // AUTH.addUserToGroup();
    
        Test.stopTest();
  }
    static testMethod void ACETUserTriggerHandlerTestMethod3()
  {
    
   RecordType myRecordType = [select id from RecordType where SobjectType='Account' AND IsPersonType=True limit 1];

   Account acc = new Account(
     //Name='test',
     FirstName= 'test',
       LastName='lastTest',
       PersonEmail='' ,
       
    Recordtypeid=myRecordType.Id);
   insert acc;
     
      Contact objContact = [Select id, FirstName, LastName from Contact where AccountId=:acc.Id];
      Profile p = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Community User' LIMIT 1]; 
       User usr = new User(
                            LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                            Email = 'abc@optum.com',
                           Username = 'abc@optum.com',
                            profileId=p.Id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Offshore',
                            ContactId = objContact.Id
                           
         );
     System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    insert usr; }
      
      
  }  
    @istest public static void testmethod4(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpz@optum.com.acet',
            Alias = 'batman',
            Email='zzznpz123@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarro',
            Lastname='yavano',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            Id provGroupRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
            Id provUserRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
            Account ac = new Account();
            ac.Name = 'ProviderGroupyarro';
            ac.RecordTypeId = provGroupRTId;
            insert ac;
            Account provUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'Provider',
                LastName = 'yarro',
                PersonEmail = 'yarroyevano@optum.com.acet',
                Provider_Group__c = ac.Id,
                RecordTypeId = provUserRTId
            );
            insert provUser;
            Id provAffRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
            Account acff = new Account();
            acff.Name = 'ProviderAffyarro';
            acff.RecordTypeId = provAffRTId;
            insert acff;
            Contact c = [SELECT Id FROM Contact WHERE AccountId =: provUser.Id];
            AccountContactRelation acrPPA = new AccountContactRelation();
            acrPPA.AccountId = acff.id;
            acrPPA.ContactId = c.id;
            acrPPA.Relationship__c = 'Provider User';
            insert acrPPA;
            Program__c pgm = new Program__c();
            pgm.Program__c = 'Complex Care';
            insert pgm;
            List<Member_Affiliation__c> memberAffilList = new List<Member_Affiliation__c>();
            for (Integer i = 0; i < 5; i++) {
                Member_Affiliation__c mAffil = new Member_Affiliation__c();
                mAffil.Provider__c = provUser.Id;
                mAffil.Population__c = 'Adult';
                mAffil.Program__c = pgm.Id;
                mAffil.Provider_Affiliation__c = acff.Id;
                mAffil.Email__c='yarroyevano' + i + '@optum.com.acet';
                mAffil.Enrollment_Date__c = system.today();
                mAffil.Date_Of_Birth__c = System.today();
                mAffil.Member__c=ac.Id;
                mAffil.Status__c=true;    
                memberAffilList.add(mAffil);
            }
            insert memberAffilList;
            test.starttest();
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Provider User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarro';
            user.LastName = 'yevvanohe';
            user.Username = 'ABCD1234rrr@optum.com.acet';
            user.CommunityNickname = 'testUser123rrr';
            user.Alias = 't12';
            user.Email = 'noyarro@optum.com.acet';
            user.IsActive = true;
           user.ContactId = c.Id;
            insert user;
            test.stoptest();
            //system.assertEquals(5, [select count() from Member_Affiliation__share where UserOrGroupId =:user.Id]);
        }
    }
    @istest public static void testmethod5(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpz@optum.com.acet',
            Alias = 'batman',
            Email='zzznpz123@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarro',
            Lastname='yavano',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            Id provGroupRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            Id provUserRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account ac = new Account();
            ac.Name = 'ProviderGroupyarro';
            ac.RecordTypeId = provGroupRTId;
            insert ac;
            Account provUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'Provider',
                LastName = 'yarro',
                PersonEmail = 'yarroyevano@optum.com.acet',
                RecordTypeId = provUserRTId
            );
            insert provUser;
            Id provAffRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
            Account acff = new Account();
            acff.Name = 'ProviderAffyarro';
            acff.RecordTypeId = provAffRTId;
            insert acff;
            Contact c = [SELECT Id FROM Contact WHERE AccountId =: provUser.Id];
            AccountContactRelation acrPPA = new AccountContactRelation();
            acrPPA.AccountId = acff.id;
            acrPPA.ContactId = c.id;
            insert acrPPA;
            Program__c pgm = new Program__c();
            pgm.Program__c = 'Complex Care';
            insert pgm;
            List<Member_Affiliation__c> memberAffilList = new List<Member_Affiliation__c>();
            for (Integer i = 0; i < 5; i++) {
                Member_Affiliation__c mAffil = new Member_Affiliation__c();
                mAffil.Provider__c = provUser.Id;
                mAffil.Population__c = 'Adult';
                mAffil.Program__c = pgm.Id;
                mAffil.Provider_Affiliation__c = acff.Id;
                mAffil.Email__c='yarroyevano' + i + '@optum.com.acet';
                mAffil.Enrollment_Date__c = system.today();
                mAffil.Date_Of_Birth__c = System.today();
                mAffil.Member__c=ac.Id;
                mAffil.Status__c=true;    
                memberAffilList.add(mAffil);
            }
            insert memberAffilList;
            test.starttest();
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Community User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarro';
            user.LastName = 'yevvanohe';
            user.Username = 'ABCD1234rrr@optum.com.acet';
            user.CommunityNickname = 'testUser123rrr';
            user.Alias = 't12';
            user.Email = 'noyarro@optum.com.acet';
            user.IsActive = true;
            user.ContactId = c.Id;
            user.Digital_Onboarding__c = true;
            insert user;
            test.stoptest();
        }
    }
    
    @istest public static void testmethod6(){
        Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();

   Account acc = new Account(
     //Name='test',
     FirstName= 'test',
       LastName='lastTest',
       PersonEmail='' ,
    Recordtypeid=recordTypeId1);
   insert acc;
     Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
      Account famAcc = new Account();
        famAcc.Name = 'FLTestAcc123';
        famAcc.RecordTypeId = recordTypeId;
        insert famAcc;
      Contact objContact = [Select id, FirstName, LastName from Contact where AccountId=:acc.Id];
      Accountcontactrelation acr = new Accountcontactrelation();
      acr.contactid = objContact.id;
      acr.accountid = famAcc.id;
      acr.Policy_ID__c = '0703352';
      insert acr;
      Profile p = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Community User' LIMIT 1]; 
       User usr = new User(
                            LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                            Email = 'abc@optum.com',
                           Username = 'abc@optum.com',
                            profileId=p.Id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Offshore',
                            ContactId = objContact.Id,
                          Include_SMS_invitation__c = true,
           mobilePhone = '7799331345'
                           
         );
     System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    insert usr; }
    }
  }